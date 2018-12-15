import '../Models/Complement.dart';

import '../Models/Produit.dart';
import '../Models/Client.dart';
import 'package:flutter/material.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';
import '../Database/PanierPresenter.dart';
import '../Utils/Loading.dart';
import '../Database/DatabaseHelper.dart';
import '../Utils/MyBehavior.dart';
import '../RecapitulatifCommande.dart';
import '../Utils/PriceFormatter.dart';



class Panier extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new PanierState();
}

class PanierState extends State<Panier> implements PanierContract{

  List<Produit> produits;
  double fraisLivraison ;
  int stateIndex;
  DatabaseHelper db;

  @override
  void initState() {

    db = new DatabaseHelper();
    fraisLivraison = 0.0;
    _updateView();
    super.initState();
  }


  _updateView(){
    setState(() {
      stateIndex = 0;
      new PanierPresenter(this).loadPanier();
    });
  }


  Widget researchBox(String hintText, Color bgdColor, Color textColor, Color borderColor) {
    return Container(
      margin: EdgeInsets.only(left: 20.0, right: 20.0),
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      decoration: new BoxDecoration(
          color: bgdColor,
          border: new Border(
            top: BorderSide(
                color: borderColor, style: BorderStyle.solid, width: 1.0),
            bottom: BorderSide(
                color: borderColor, style: BorderStyle.solid, width: 1.0),
            left: BorderSide(
                color: borderColor, style: BorderStyle.solid, width: 1.0),
            right: BorderSide(
                color: borderColor, style: BorderStyle.solid, width: 1.0),
          )),
      child: Row(children: [
        Icon(Icons.search, color: textColor, size: 25.0,),
        Expanded(
            child: Container(
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                child: TextFormField(
                    autofocus: false,
                    autocorrect: false,
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: hintText,
                        hintStyle: TextStyle(color: textColor)),
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black45,
                      fontWeight: FontWeight.bold,
                    ))))
      ]),
    );
  }


  Widget getDivider(double height, {bool horizontal}){

    return Container(
      width: horizontal ? double.infinity : height,
      height: horizontal ? height : double.infinity,
      color: Color.fromARGB(15, 0, 0, 0),
    );
  }


  Widget getOptionsSection(int prod_index) {

    List<Complement> complements = new List();
    for(int i = 0; i < produits[prod_index].options.length; i++)
      for(int j = 0; j < produits[prod_index].options[i].complements.length; j++)
        complements.add(produits[prod_index].options[i].complements[j]);

    return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 10.0),
              child: Text("Complements (" + complements.length.toString() + " produits)",
                style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            Expanded(child: Container(
              child: ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: ListView.builder(
                    padding: EdgeInsets.all(0.0),
                      scrollDirection: Axis.vertical,
                      itemCount: complements.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return getComplementItem(complements[index]);
                      })),
            ))
          ],
        ));
  }


  Widget getComplementItem(Complement complement){

    return Container(
      height: 80.0,
      margin: EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Image.network(
              complement.image,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.contain,
            ), flex: 2,
          ),
          Expanded(child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0),
            height: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text(complement.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0
                    )
                ),
                Text(complement.price == 0 ? "Offert" : PriceFormatter.formatPrice(price: complement.price) ,
                    style: TextStyle(
                        color: Colors.lightGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0
                    )
                )
              ],
            ),
          ),flex: 3,)
        ],
      ),
    );
  }


  double getItemTotal(int index){

    double total = produits[index].prix;
    if(produits[index].options == null || produits[index].options.length == 0) return total * produits[index].nbCmds;
    for(int i = 0; i < produits[index].options.length; i++){
      if(produits[index].options[i].complements == null || produits[index].options[i].complements.length == 0) continue;
      for(int j = 0; j < produits[index].options[i].complements.length; j++){
        if(produits[index].options[i].complements[j].selected)
          total += produits[index].options[i].complements[j].price;
      }
    }
    return total * produits[index].nbCmds;
  }


  Widget getItem(int index){

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: <Widget>[
          Expanded(child: Container(
            padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
            child: Row(
              children: <Widget>[
                Expanded(child: Image.network(
                  produits[index].photo,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ), flex: 1,),
                Expanded(child:Container(
                  margin: EdgeInsets.only(left: 15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        child: Text(produits[index].name,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: new TextStyle(
                              color: Colors.black,
                              decoration: TextDecoration.none,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ))
                        ,),
                      Container(
                        width: double.infinity,
                        child: Text(
                            PriceFormatter.formatPrice(price: produits[index].prix),
                            textAlign: TextAlign.left,
                            style: new TextStyle(
                              color: Colors.lightGreen,
                              decoration: TextDecoration.none,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                      Container(
                        width: double.infinity,
                        child: Text(
                            produits[index].description == null ? "" : produits[index].description,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: new TextStyle(
                              color: Colors.black,
                              decoration: TextDecoration.none,
                              fontSize: 13.0,
                              fontWeight: FontWeight.normal,
                            )),
                      )
                    ],
                  ),
                ),
                  flex: 1,)
              ],
            ),
          ), flex: 4,),


          getDivider(1.0, horizontal: true),

          produits[index].options != null && produits[index].options.length > 0 ?
          Expanded(
            child: getOptionsSection(index),
            flex: 3,
          )
              : Container(),

          produits[index].options != null && produits[index].options.length > 0 ? getDivider(2.0, horizontal: true) : Container(),

          Expanded(child: Container(
            padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0, bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  //color: Colors.grey,
                    child : Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: 10.0),
                          child: Icon(Icons.favorite_border, color: produits[index].isFavoris ? Color.fromARGB(255, 255, 215, 0): Colors.lightGreen, size: 20.0,),
                        ),
                        getDivider(2.0, horizontal: false),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Icon(Icons.delete, color: Colors.lightGreen, size: 20.0,),
                        ),
                        PositionedTapDetector(
                          onTap: (position){
                            db.deleteProduit(produits[index]);
                            produits.removeAt(index);
                            if(produits.length == 0)
                              _updateView();
                            else
                              setState(() {});
                          },
                          child: Text(
                              "SUPPRIMER",
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                              style: new TextStyle(
                                color: Colors.lightGreen,
                                decoration: TextDecoration.none,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              )),
                        )
                      ],
                    )
                ),

                Container(
                  child: Row(
                    children: <Widget>[
                      PositionedTapDetector(
                        onTap: (position){

                          if(produits[index].nbCmds > 1){
                            produits[index].qteCmder = produits[index].nbCmds - 1;
                            db.updateQuantite(produits[index]);
                            setState(() {});
                          }
                        },
                        child: Container(
                          decoration: new BoxDecoration(
                            color: Colors.lightGreen,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.remove, color: Colors.white, size: 15.0,),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10.0),
                        padding: EdgeInsets.only(left : 10.0, right: 10.0),
                        decoration: new BoxDecoration(border: new Border.all(color: Colors.lightGreen, style: BorderStyle.solid, width: 0.5)),
                        child: new Text(produits[index].nbCmds.toString(),
                            textAlign: TextAlign.left,
                            style: new TextStyle(
                              color: Colors.black,
                              decoration: TextDecoration.none,
                              fontSize: 13.0,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                      PositionedTapDetector(
                        onTap: (position){
                          produits[index].qteCmder = produits[index].nbCmds + 1;
                          db.updateQuantite(produits[index]);
                          setState(() {});
                        },
                        child: Container(
                          decoration: new BoxDecoration(
                            color: Colors.lightGreen,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.add, color: Colors.white, size: 15.0,),
                        ),
                      )
                    ],
                  ),
                )

              ],
            ),
          ), flex: 1,),

          getDivider(2.0, horizontal: true),

          Container(
            margin: EdgeInsets.only(top: 10.0),
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Sous-total",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Text(PriceFormatter.formatPrice(price: (getItemTotal(index))),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold
                    ),
                    textAlign: TextAlign.left,
                  )
                ]
            ),
          )

        ],
      ),
    );
  }


  Widget getPricesSection(){

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          margin: EdgeInsets.only(bottom: 5.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Frais livraison",
                  style: TextStyle(
                      color: Colors.black38,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.left,
                ),
                Text(PriceFormatter.formatPrice(price: this.fraisLivraison),
                  style: TextStyle(
                      color: Colors.black38,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.left,
                )
              ]
          ),
        ),

        getDivider(1.0, horizontal: true),

        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          margin: EdgeInsets.only(top: 5.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Total",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.left,
                ),
                Text(PriceFormatter.formatPrice(price: getTotal()),
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.left,
                )
              ]),
        ),

      ],
    );
  }


  double getTotal(){

    double total = 0.0;
    for(int i = 0; i < produits.length; i++){
      total = total + getItemTotal(i);
    }
    return total + fraisLivraison;
  }


  Widget getSceneView(){

    switch(stateIndex){

      case 0 :
        return Container(color: Colors.white, child: ShowLoadingView(),);

      case 1 : return Container(
        color: Colors.white,
        child: Center(child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 10.0),
              child: Icon(Icons.remove_shopping_cart, size: 60.0, color: Colors.lightGreen,),
            ),
            Text("Panier vide. \n\nAucun produit trouvé dans le panier",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  color: Colors.black
              ),)
          ],
        ),),
      );

      default:
        return Column(
          children: <Widget>[
//            Expanded(
//              child: Container(
//                margin: EdgeInsets.only(top: 5.0),
//                color: Colors.white,
//                child: Center(
//                  child: researchBox("Chercher ici", Color.fromARGB(15, 0, 0, 0), Colors.grey, Colors.transparent) ,
//                ),
//              ),
//              flex: 1,
//            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 4.0, bottom: 5.0),
                padding: EdgeInsets.only(top: 5.0),
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      color: Colors.white,
                      child: Center(
                        child: Container(
                          width: double.infinity,
                          child: Text("MON PANIER (" + produits.length.toString() + " ARTICLES)",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.0,
                                fontWeight: FontWeight.normal
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: ScrollConfiguration(behavior: MyBehavior(), child: PageView.builder(
                            scrollDirection: Axis.horizontal,
                            controller: null,
                            itemCount: produits.length,
                            itemBuilder: (BuildContext ctxt, int index) {
                              return getItem(index);
                            })),
                      )
                    ),

                    Container(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
                      color: Colors.white,
                      child: getPricesSection(),
                    ),

                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Center(
                        child: PositionedTapDetector(
                            onTap: (position) {
                              db.loadClient().then((Client client){
                                Navigator.of(context).push(
                                    new MaterialPageRoute(builder: (context) => RecapitulatifCommande(produits: produits, fraisLivraison: fraisLivraison, client: client)))
                                    .then((value){
                                  _updateView();
                                });
                              });
                            },
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.lightGreen,
                                      style: BorderStyle.solid,
                                      width: 1.0
                                  ),
                                  color: Colors.lightGreen
                              ),
                              child: Text("FINALISER",
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: new TextStyle(
                                    color: Colors.white,
                                    decoration: TextDecoration.none,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  )),
                            )),
                      ),

                    )

                  ],
                )
                ,
              ),
              flex: 7,
            ),
          ],
        );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color.fromARGB(25, 0, 0, 0),
        child: getSceneView()
    );
  }


  @override
  void onLoadingError() {

    setState(() {
      stateIndex = 1;
    });
  }


  @override
  void onLoadingSuccess(List<Produit> produits) {

    setState(() {
      this.produits = produits;
      stateIndex = 2;
    });
  }
}
