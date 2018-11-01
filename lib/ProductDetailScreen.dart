import 'package:flutter/material.dart';
import 'Utils/AppBars.dart';
import 'Models/Produit.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';
import 'Database/DatabaseHelper.dart';

class ProductDetailScreen extends StatefulWidget {
  ProductDetailScreen(this.produit);
  final Produit produit;

  @override
  State<StatefulWidget> createState() => new ProductDetailScreenState();
}

class ProductDetailScreenState extends State<ProductDetailScreen> {

  bool isProductInCart;
  DatabaseHelper db;

  @override
  void initState(){
    db = new DatabaseHelper();
    widget.produit.qteCmder = 1;
    super.initState();
    db.isInCart(widget.produit).then((inCart){isProductInCart = inCart;});
  }

  Widget getDivider(double height, {bool horizontal}) {
    return Container(
      width: horizontal ? double.infinity : height,
      height: horizontal ? height : double.infinity,
      color: Color.fromARGB(15, 0, 0, 0),
    );
  }

  Widget getContent(){

    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 5.0, bottom: 10.0),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: Container(
                              child: Center(
                                child: Text(widget.produit.name,
                                    textAlign: TextAlign.center,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 25.0,
                                        fontWeight: FontWeight.bold)),
                              ),
                            )),
                        Align(
                            alignment: Alignment.topCenter,
                            child: Icon(
                              Icons.restaurant,
                              size: 40.0,
                              color: Colors.red,
                            )
                        ),
                      ],
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: Image.network(
                        widget.produit.photo,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.fill,
                      ),
                    ),
                    flex: 3,
                  ),
                  getDivider(1.0, horizontal: true),
                  Expanded(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Prix",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.0,
                                ),
                              ),
                              Text(
                                "Quantité",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.0,
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                widget.produit.prix.toString() + "€",
                                style: TextStyle(
                                    color: Colors.lightGreen,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    PositionedTapDetector(
                                      onTap: (position) {
                                        if (widget.produit.nbCmds > 1) {
                                          widget.produit.qteCmder =
                                              widget.produit.nbCmds - 1;
                                          if(isProductInCart) db.updateQuantite(widget.produit);
                                          setState(() {});
                                        }
                                      },
                                      child: Container(
                                        decoration: new BoxDecoration(
                                          color: Colors.lightGreen,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.remove,
                                          color: Colors.white,
                                          size: 20.0,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      padding: EdgeInsets.only(
                                          left: 10.0, right: 10.0),
                                      decoration: new BoxDecoration(
                                          border: new Border.all(
                                              color: Colors.lightGreen,
                                              style: BorderStyle.solid,
                                              width: 0.5)),
                                      child: new Text(
                                          widget.produit.nbCmds.toString(),
                                          textAlign: TextAlign.left,
                                          style: new TextStyle(
                                            color: Colors.black,
                                            decoration: TextDecoration.none,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ),
                                    PositionedTapDetector(
                                      onTap: (position) {
                                        widget.produit.qteCmder =
                                            widget.produit.nbCmds + 1;
                                        if(isProductInCart) db.updateQuantite(widget.produit);
                                        setState(() {});
                                      },
                                      child: Container(
                                        decoration: new BoxDecoration(
                                          color: Colors.lightGreen,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 20.0,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      color: Color.fromARGB(15, 0, 0, 0),
                      padding: EdgeInsets.symmetric(vertical: 2.0),
                      child: RichText(
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 4,
                        text: TextSpan(
                          children: [
                            new TextSpan(
                                text: 'Description\n',
                                style: new TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.0,
                                )),
                            new TextSpan(
                                text: widget.produit.description == null || widget.produit.description.length == 0 ? "Aucune description donnée sur ce produit" : widget.produit.description,
                                style: new TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.0,
                                )),
                          ],
                        ),
                      ),
                    ),
                    flex: 1,
                  ),
                ],
              ),
            ),
            flex: 6,
          ),
          getDivider(6.0, horizontal: true),
          Expanded(
            child: Container(
                color: Colors.white,
                padding: EdgeInsets.only(
                    left: 20.0, right: 20.0, top: 10.0, bottom: 15.0),
                child:
                RaisedButton(
                  onPressed: () {

                    if(isProductInCart){
                      db.deleteProduit(widget.produit);
                      setState(() {});
                    }else {
                      db.addProduit(widget.produit).then((
                          insertedId) {
                        if (insertedId > 0) setState(() {});
                      }).catchError((error) {
                        print("Erreur : " + error.toString());
                      });
                    }

                  },
                  child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        isProductInCart ? "RETIRER DU PANIER" : "AJOUTER AU PANIER",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      )
                  ),
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(0.0)),
                  textColor: Colors.white,
                  color: Colors.lightGreen,
                  elevation: 1.0,
                )

            ),
            flex: 1,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Material(
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              HomeAppBar(), // logo allozoe
              Expanded(
                  child: FutureBuilder(
                      future: db.getProduit(widget.produit.id),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {

                        if (snapshot.hasData) {
                          Produit prod = snapshot.data;

                          if(prod.id < 0){ // si le produit n'est pas dans le panier
                            isProductInCart = false;
                          }else {
                            isProductInCart = true;
                            widget.produit.qteCmder = prod.nbCmds;
                          }

                          return getContent();

                        }else return Container(
                            height: double.infinity,
                            width: double.infinity,
                            child: Center(child: CircularProgressIndicator(),)
                        );
                      }
                  )
              )
            ],
          ),
          Container(
            height: AppBar().preferredSize.height,
            child: AppBar(
              iconTheme: IconThemeData(
                color: Colors.black, //change your color here
              ),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            ),
          )
        ],
      ),
    );


  }


}

