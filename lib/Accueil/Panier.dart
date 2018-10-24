import '../Models/Produit.dart';
import 'package:flutter/material.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';
import '../Database/PanierPresenter.dart';
import '../Utils/Loading.dart';
import '../Database/DatabaseHelper.dart';
import '../Utils/MyBehavior.dart';


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
    fraisLivraison = 1000.0;
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

  Widget getItem(int index){

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: <Widget>[

          Expanded(child: Container(
            padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 15.0, bottom: 15.0),
            child: Row(
              children: <Widget>[
                Expanded(child: Image.network(
                  produits[index].photo,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ), flex: 1,),
                Expanded(child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 12.0, left: 15.0),
                      width: double.infinity,
                      child: Text(produits[index].name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: new TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.none,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ))
                      ,),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(left: 15.0, bottom: 12.0),
                      child: Text(
                          produits[index].prix.toString(),
                          textAlign: TextAlign.left,
                          style: new TextStyle(
                            color: Colors.lightGreen,
                            decoration: TextDecoration.none,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          )),
                    ),

                    Expanded(child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(left: 15.0),
                      child: Text(
                          produits[index].description == null ? "" : produits[index].description,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: new TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.none,
                            fontSize: 13.0,
                            fontWeight: FontWeight.normal,
                          )),
                    ))
                  ],
                ), flex: 1,)
              ],
            ),
          ), flex: 4,),


          getDivider(1.0, horizontal: true),


          Expanded(child: Container(
            padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0, bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    child : Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: 10.0),
                          child: Icon(Icons.favorite_border, color: produits[index].isFavoris ? Color.fromARGB(255, 255, 215, 0): Colors.lightGreen, size: 25.0,),
                        ),
                        getDivider(1.0, horizontal: false),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Icon(Icons.delete, color: Colors.lightGreen, size: 25.0,),
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
                          child: Icon(Icons.remove, color: Colors.white, size: 20.0,),
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
                              fontSize: 15.0,
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
                          child: Icon(Icons.add, color: Colors.white, size: 20.0,),
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
                  Text((produits[index].prix * produits[index].nbCmds).truncateToDouble().toString(),
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
                Text(this.fraisLivraison.toString(),
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
                Text(getTotal().toString(),
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
      total = total + produits[i].prix * produits[i].nbCmds;
    }
    return (total + fraisLivraison).truncateToDouble();
  }

  void _finaliserCommandePanier(){


    db.clearPanier();
    _updateView();
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
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 5.0),
                color: Colors.white,
                child: Center(
                  child: researchBox("Chercher ici", Color.fromARGB(15, 0, 0, 0), Colors.grey, Colors.transparent) ,
                ),
              ),
              flex: 1,
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 4.0, bottom: 5.0),
                color: Colors.white,
                child: Column(
                  children: <Widget>[

                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        color: Color.fromARGB(15, 0, 0, 0),
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
                      flex: 1,
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
                      ),
                      flex: 7,
                    ),

                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
                        color: Colors.white,
                        child: getPricesSection(),
                      ),
                      flex: 2,
                    ),

                    Expanded(child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Center(
                        child: PositionedTapDetector(
                            onTap: (position) {
                              _finaliserCommandePanier();
                            },
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 10.0),
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

                    ), flex: 2,)

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
