import 'package:client_app/Models/Client.dart';
import 'package:client_app/StringKeys.dart';
import 'package:client_app/Utils/AppBars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';
import 'package:stripe_flutter/stripe_flutter.dart';
import 'package:stripe_api/model/card.dart';
import 'package:stripe_api/stripe_api.dart';

import '../DAO/Presenters/AddCardPresenter.dart';
import '../DAO/Presenters/DeleteCardPresenter.dart';
import '../DAO/Presenters/SendCommandePresenter.dart';
import '../Database/DatabaseHelper.dart';
import '../Models/CreditCard.dart';
import '../Models/Produit.dart';
import '../Utils/PriceFormatter.dart';
//import 'strip/stripe/stripe.dart';

class CardListScreen extends StatefulWidget {
  final bool forPaiement;
  final double montantPaiement;
  List<CreditCard> cards;
  final List<Produit> produits;
  final String address, phone;
  final int paymentMode;
  final String langue;
  final String type;
  final String note;

  CardListScreen(
      {@required this.forPaiement,
      this.montantPaiement,
      this.cards,
      this.produits,
      this.address,
      this.phone,
      this.paymentMode,
      this.type,
      this.note,
      this.langue});

  createState() => new CardListScreenState();
}

class CardListScreenState extends State<CardListScreen>
    implements SendCommandeContract, AddCardContract, DeleteCardContract {
  int indexSelected;
  bool isLoading;
  int paiementModeIndex; // 1 = carte bancaire et 2 = ticket restaurant
  String paiementModeName;
  SendCommandePresenter _presenter;
  DeleteCardPresenter _deleteCardPresenter;
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _card, _date, _code;
  final formKey = GlobalKey<FormState>();
  final montantKey = new GlobalKey<FormState>();
  String _montant;
  final TextEditingController controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    paiementModeIndex = widget.paymentMode;
    _dropDownMenuItems = getDropDownMenuItems();
    paiementModeName = _dropDownMenuItems[paiementModeIndex == 1 ? 0 : 1].value;
    indexSelected = 0;
    isLoading = false;
    _presenter = new SendCommandePresenter(this);
    _deleteCardPresenter = new DeleteCardPresenter(this);
    Stripe.init('pk_live_eo4MYvhD0gazKbeMzchjmrSU');
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    if ("fr" == widget.langue) {
      List _paymentModes = ["Carte Bancaire", "Ticket Restaurant"];
      for (String paymentMode in _paymentModes) {
        items.add(new DropdownMenuItem(
            value: paymentMode, child: new Text(paymentMode)));
      }
    } else {
      List _paymentModes = ["Bank card", "Restaurant Ticket"];
      for (String paymentMode in _paymentModes) {
        items.add(new DropdownMenuItem(
            value: paymentMode, child: new Text(paymentMode)));
      }
    }
    return items;
  }

  void changedDropDownItem(String paymentMode) {
    setState(() {
      paiementModeIndex = paymentMode ==
              getLocaleText(context: context, strinKey: StringKeys.CARD_BANK)
          ? 1
          : 2;
      paiementModeName = paymentMode;
      if (paymentMode !=
          getLocaleText(context: context, strinKey: StringKeys.CARD_BANK))
        indexSelected = 0;
    });
  }

  void _showDialog(String title) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(getLocaleText(
              context: context, strinKey: StringKeys.AVERTISSEMENT)),
          content: new Text(title),
          actions: <Widget>[
            new FlatButton(
              child: new Text(
                  getLocaleText(context: context, strinKey: StringKeys.OK_BTN)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _submit() {
    double prix = 0.0;

    if (paiementModeIndex == 2) {
      montantKey.currentState.save();

      if (_montant.length == 0) {
        _showDialog(getLocaleText(
            context: context, strinKey: StringKeys.CARD_TICKET_REQUIRE));
        return;
      }

      try {
        prix = double.parse(_montant);
      } catch (error) {
        _showDialog(getLocaleText(
            context: context, strinKey: StringKeys.CARD_AMOUNT_INVALIDE));
        return;
      }

      if (prix < widget.montantPaiement) {
        _showDialog(getLocaleText(
            context: context, strinKey: StringKeys.CARD_TICKET_LOW));
        return;
      }

      if (prix < 15.0) {
        _showDialog(getLocaleText(
            context: context, strinKey: StringKeys.CARD_TICKET_MIN));
        return;
      }
    } else if (paiementModeIndex == 1) {
      if (widget.cards == null || widget.cards.length == 0) {
        return;
      }
    }

    setState(() {
      isLoading = true;
    });

    // TODO : formatter l'envoi des commandes selon les restaurants si necessaires ici
    _presenter.commander(
        widget.produits,
        widget.address,
        widget.phone,
        widget.type,
        widget.note,
        {"id": paiementModeIndex == 1 ? widget.cards[indexSelected].id : -1},
        {
          "id": -1,
          "value": paiementModeIndex == 2 ? double.parse(_montant) : 0.0
        },
        paiementModeIndex,
        false);
  }

  Widget getCardItem(int index) {
    return GestureDetector(
      onLongPress: () {
        if (!widget.forPaiement) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              // return object of type Dialog
              return AlertDialog(
                title: new Text(getLocaleText(
                    context: context, strinKey: StringKeys.AVERTISSEMENT)),
                content: new Text(getLocaleText(
                    context: context,
                    strinKey: StringKeys.CARD_TICKET_DEL_AVERT)),
                actions: <Widget>[
                  // usually buttons at the bottom of the dialog
                  new FlatButton(
                    child: new Text(getLocaleText(
                        context: context,
                        strinKey: StringKeys.PANIER_SUPPRIMER)),
                    onPressed: () {
                      Navigator.of(context).pop();

                      setState(() {
                        isLoading = true;
                      });

                      DatabaseHelper().loadClient().then((Client client) {
                        _deleteCardPresenter.deleteCreditCard(
                            clientID: client.id,
                            card_id: widget.cards[index].id);
                      }).catchError((error) {
                        setState(() {
                          isLoading = false;
                        });
                        _showDialog(getLocaleText(
                            context: context,
                            strinKey: StringKeys.CARD_ACCOUNT_UNKNOW));
                      });
                    },
                  ),

                  new FlatButton(
                    child: new Text(getLocaleText(
                        context: context, strinKey: StringKeys.CANCEL_BTN)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            },
          );
        }
      },
      child: Container(
        height: 60.0,
        margin: EdgeInsets.symmetric(vertical: 10.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1.0),
        ),
        padding:
            EdgeInsets.only(left: 20.0, right: 10.0, top: 10.0, bottom: 10.0),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.credit_card,
              size: 30.0,
            ),
            Expanded(
                child: Container(
              margin: EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                getLocaleText(
                        context: context,
                        strinKey: StringKeys.PROFILE_NUM_CARTE) +
                    "\n" +
                    "**** **** **** " +
                    widget.cards[index].card_number,
                style: TextStyle(fontSize: 16.0),
              ),
            )),
            widget.forPaiement
                ? PositionedTapDetector(
                    onTap: (position) {
                      setState(() {
                        indexSelected = index;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: indexSelected == index
                              ? Colors.lightGreen
                              : Colors.transparent,
                          border: Border.all(color: Colors.grey, width: 1.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: indexSelected == index
                            ? Icon(
                                Icons.check,
                                size: 10.0,
                                color: Colors.white,
                              )
                            : Icon(
                                Icons.check_box_outline_blank,
                                size: 10.0,
                                color: Colors.transparent,
                              ),
                      ),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  Widget getCardPaiementContent() {
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(top: 10.0, bottom: 5.0),
          child: Text(
              widget.cards == null || widget.cards.length == 0
                  ? getLocaleText(
                      context: context, strinKey: StringKeys.CARD_NO_CARD_FOUND)
                  : (widget.forPaiement
                      ? getLocaleText(
                          context: context,
                          strinKey: StringKeys.CARD_SELECT_CARD)
                      : getLocaleText(
                          context: context,
                          strinKey: StringKeys.CARD_YOUR_CARD)),
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 17.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold)),
        ),
        widget.cards != null && widget.cards.length > 0
            ? Flexible(
                child: SingleChildScrollView(
                  child: ListView.builder(
                      padding: EdgeInsets.all(0.0),
                      itemCount: widget.cards.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        return getCardItem(index);
                      }),
                ),
              )
            : Container(),
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(top: 5.0),
          margin: EdgeInsets.only(bottom: 20.0),
          child: PositionedTapDetector(
            onTap: (position) {
              StripeView.setPublishableKey("pk_test");
              //addCardDialog();
              StripeView.getCard().then((String token) {
                List<String> result = token.split("/");
                print("reslut incation:" +
                    result.toString()); //your stripe card source token
                setState(() {
                  isLoading = true;
                });

                _saveCard(result[0], result[1], result[2], result[3]);
              });
            },
            child: Text(
                widget.forPaiement
                    ? getLocaleText(
                        context: context,
                        strinKey: StringKeys.CARD_ANOTHER_CARD)
                    : getLocaleText(
                        context: context, strinKey: StringKeys.CARD_ADD_CARD),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 17.0,
                    color: Colors.lightGreen,
                    fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Widget getTicketPaiementContent() {
    return ListView(
      children: <Widget>[
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(vertical: 20.0),
          child: Text(
              getLocaleText(
                  context: context,
                  strinKey: StringKeys.CARD_TICKET_AMOUNT_CARD),
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 17.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold)),
        ),
        Container(
            padding: EdgeInsets.only(top: 15.0, bottom: 20.0),
            child: Form(
                key: montantKey,
                child: TextFormField(
                    onSaved: (val) {
                      _montant = val;
                    },
                    textAlign: TextAlign.left,
                    autofocus: false,
                    autocorrect: false,
                    maxLines: 1,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        contentPadding: new EdgeInsets.all(0.0),
                        //border: InputBorder.none,
                        hintText: getLocaleText(
                            context: context,
                            strinKey: StringKeys.CARD_TICKET_AMOUNT),
                        hintStyle: TextStyle(
                            fontSize: 13.0,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold)),
                    style: TextStyle(
                        fontSize: 13.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold))))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                HomeAppBar(),
                widget.forPaiement
                    ? Container(
                        color: Colors.white,
                        padding: EdgeInsets.only(top: 20.0,bottom: 8.0),
                        width: double.infinity,
                        child: Text(
                            getLocaleText(
                                    context: context,
                                    strinKey: StringKeys.CARD_AMOUNT_PAY) +
                                PriceFormatter.formatPrice(
                                    price: widget.montantPaiement),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 17.0,
                                color: Colors.lightGreen,
                                fontWeight: FontWeight.bold)),
                      )
                    : Container(),
                widget.forPaiement
                    ? Container(
                        width: double.infinity,
                        color: Colors.white,
                        child: Center(
                          child: DropdownButton(
                            value: paiementModeName,
                            items: _dropDownMenuItems,
                            onChanged: changedDropDownItem,
                          ),
                        ),
                      )
                    : Container(),
                Expanded(
                    child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: paiementModeIndex == 1
                      ? getCardPaiementContent()
                      : getTicketPaiementContent(),
                )),
                widget.forPaiement
                    ? Container(
                        padding: EdgeInsets.only(
                            left: 20.0, right: 20.0, bottom: 15.0),
                        color: Colors.white,
                        child: PositionedTapDetector(
                            onTap: (position) {
                              _submit();
                            },
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.lightGreen,
                                      style: BorderStyle.solid,
                                      width: 1.0),
                                  color: paiementModeIndex == 1 &&
                                          (widget.cards == null ||
                                              widget.cards.length == 0)
                                      ? Colors.black38
                                      : Colors.lightGreen),
                              child: Text(
                                  getLocaleText(
                                      context: context,
                                      strinKey: StringKeys.CARD_BTN_PAY),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: new TextStyle(
                                    color: paiementModeIndex == 1 &&
                                            (widget.cards == null ||
                                                widget.cards.length == 0)
                                        ? Colors.black54
                                        : Colors.white,
                                    decoration: TextDecoration.none,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  )),
                            )),
                      )
                    : Container()
              ],
            ),
            Container(
              height: AppBar().preferredSize.height+50,
              child: AppBar(
                iconTheme: IconThemeData(
                  color: Colors.black, //change your color here
                ),
                backgroundColor: Colors.transparent,
                elevation: 0.0,
              ),
            ),
            isLoading
                ? Container(
                    color: Colors.black26,
                    width: double.infinity,
                    height: double.infinity,
                    child: Center(
                      child: new CircularProgressIndicator(),
                    ),
                  )
                : IgnorePointer(ignoring: true)
          ],
        ),
      ),
    );
  }

  @override
  void onCommandError() {
    setState(() {
      isLoading = false;
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Echec"),
          content: new Text(getLocaleText(
              context: context, strinKey: StringKeys.CARD_PAYMENT_ERROR)),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(getLocaleText(
                  context: context, strinKey: StringKeys.RETRY_BTN)),
              onPressed: () {
                Navigator.of(context).pop();
                _submit();
              },
            ),

            new FlatButton(
              child: new Text(getLocaleText(
                  context: context, strinKey: StringKeys.CANCEL_BTN)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
/*
  addCardDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Card credit infos"),
          content: new Form(
              key: formKey,
              child: ListView(
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.all(0.0),
                children: <Widget>[
                  //alignment: Alignment.topCenter,
                  new Column(children: <Widget>[
                    new SizedBox(height: 12.0),
                    Container(
                      child: Row(
                        children: [
                          Icon(Icons.credit_card, color: null),
                          Expanded(
                              child: Container(
                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: controller,
                              onSaved: (String val) {
                                _card = val;
                              },
                              inputFormatters: [
                                CardNumberFormatter(
                                    onCardBrandChanged: (brand) {
                                  print('onCardBrandChanged : ' + brand);
                                }, onCardNumberComplete: () {
                                  print('onCardNumberComplete');
                                }, onShowError: (isError) {
                                  print('Is card number valid ? ${!isError}');
                                }),
                              ],
                            ),
                          )),
                          //Icon(Icons.check, color: null),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, color: null),
                          Expanded(
                              child: Container(
                                  padding:
                                      EdgeInsets.only(left: 10.0, right: 10.0),
                                  child: TextFormField(
                                      autofocus: false,
                                      autocorrect: false,
                                      maxLines: 1,
                                      keyboardType: TextInputType.text,
                                      inputFormatters: [
                                        MaskedTextInputFormatter(
                                          mask: 'xx/xx',
                                          separator: '/',
                                        ),
                                      ],
                                      onSaved: (String val) {
                                        _date = val;
                                      },
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "MM/AA",
                                      ),
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      )))),
                          Icon(Icons.check, color: null),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Icon(Icons.lock, color: null),
                          Expanded(
                              child: Container(
                                  padding:
                                      EdgeInsets.only(left: 10.0, right: 10.0),
                                  child: TextFormField(
                                      autofocus: false,
                                      autocorrect: false,
                                      maxLines: 1,
                                      onSaved: (String val) {
                                        _code = val;
                                      },
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Code de sécurite",
                                      ),
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      )))),
                          Icon(Icons.check, color: null),
                        ],
                      ),
                    )
                  ])
                ],
              )),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              onPressed: _saveCard(),
              child: new Text('Enregistrer'),
            )
          ],
        );
      },
    );
  }*/

  Container buildEntrieRow(IconData startIcon, IconData endIcon,
      String hintText, TextInputType inputType) {
    Color color = Colors.grey;

    return Container(
      child: Row(
        children: [
          Icon(startIcon, color: color),
          Expanded(
              child: Container(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  child: TextFormField(
                      autofocus: false,
                      autocorrect: false,
                      maxLines: 1,
                      keyboardType: inputType,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: hintText,
                      ),
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      )))),
          Icon(endIcon, color: color),
        ],
      ),
    );
  }

  void _saveCard(String number, String expMonth, String expYear, String cvc) {
    StripeCard card = new StripeCard(
        number: number,
        cvc: cvc,
        expMonth: int.parse(expMonth),
        expYear: int.parse(expYear));
    card.name = 'client';
    Stripe.instance.createCardToken(card).then((c) {
      print("result " + c.toString());
      //_showDialog(c.id);
      /* if (widget.forPaiement) {
        new DatabaseHelper().loadClient().then((Client client) {
          _presenter.commander(
              widget.produits,
              widget.address,
              widget.phone,
              {"id": 0, "token_stripe": c.id},
              {
                "id": -1,
              },
              1,
              true);
        });
      } else {*/
      new DatabaseHelper().loadClient().then((Client client) {
        new AddCardPresenter(this)
            .addCreditCard(clientID: client.id, token_stripe: c.id);
      });
      //}

      // return CustomerSession.instance.addCustomerSource(c.id);
    });
  }

  @override
  void onCommandSuccess() {
    new DatabaseHelper().clearPanier(); // vide la panier

    new DatabaseHelper().getClientCards().then((List<CreditCard> cards) {
      widget.cards = cards;
      setState(() {
        isLoading = false;
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Succes"),
            content: new Text(getLocaleText(
                context: context, strinKey: StringKeys.CARD_PAYMENT_SUCCESS)),
            actions: <Widget>[
              new FlatButton(
                child: new Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop(); // ferme le dialogue
                  Navigator.of(context).pop(); // rentre au recapitulatif
                  Navigator.of(context).pop(); // rentre au panier
                },
              )
            ],
          );
        },
      );
    });
  }

  @override
  void onConnectionError() {
    setState(() {
      isLoading = false;
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(getLocaleText(
              context: context,
              strinKey: StringKeys.ERROR_CONNECTION_FAILED_TITLE)),
          content: new Text(getLocaleText(
              context: context, strinKey: StringKeys.ERROR_CONNECTION_FAILED)),
          actions: <Widget>[
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void onRequestError() {
    setState(() {
      isLoading = false;
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Echec"),
          content: new Text(getLocaleText(
              context: context, strinKey: StringKeys.ERROR_OCCURED)),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(getLocaleText(
                  context: context, strinKey: StringKeys.RETRY_BTN)),
              onPressed: () {
                Navigator.of(context).pop();
                _submit();
              },
            )
          ],
        );
      },
    );
  }

  @override
  void onRequestSuccess() {
    new DatabaseHelper().getClientCards().then((List<CreditCard> cards) {
      widget.cards = cards;
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void onDeleteError() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Echec"),
          content: new Text(getLocaleText(
              context: context, strinKey: StringKeys.CARD_ERROR_DELETED)),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(getLocaleText(
                  context: context, strinKey: StringKeys.RETRY_BTN)),
              onPressed: () {
                Navigator.of(context).pop();
                _submit();
              },
            )
          ],
        );
      },
    );
  }

  @override
  void onDeleteSuccess() {
    new DatabaseHelper().getClientCards().then((List<CreditCard> cards) {
      widget.cards = cards;
      setState(() {
        isLoading = false;
        _showDialog(getLocaleText(
            context: context, strinKey: StringKeys.CARD_BTN_DELETED));
      });
    }).catchError((error) {
      setState(() {
        isLoading = false;
      });
    });
  }
}

class CardItem extends StatelessWidget {
  final StripeCard card;

  const CardItem({Key key, this.card}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class MaskedTextInputFormatter extends TextInputFormatter {
  final String mask;
  final String separator;

  MaskedTextInputFormatter({
    @required this.mask,
    @required this.separator,
  }) {
    assert(mask != null);
    assert(separator != null);
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length > 0) {
      if (newValue.text.length > oldValue.text.length) {
        if (newValue.text.length > mask.length) return oldValue;
        if (newValue.text.length < mask.length &&
            mask[newValue.text.length - 1] == separator) {
          return TextEditingValue(
            text:
                '${oldValue.text}$separator${newValue.text.substring(newValue.text.length - 1)}',
            selection: TextSelection.collapsed(
              offset: newValue.selection.end + 1,
            ),
          );
        }
      }
    }
    return newValue;
  }
}
