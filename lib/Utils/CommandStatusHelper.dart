import 'dart:ui';
import 'package:flutter/material.dart';
import '../Models/StatusCommande.dart';


/**
 * Les statuts en paramètre sont des entiers
    1 : PENDING
    2 : APPROVED
    3: DECLINED
    4 : SHIPPED
    5: PAID
 */


String getStatusCommandValue(StatusCommande statusCommande){

  switch(statusCommande.id){
    case 1 : return "En attente de livraison";
    case 2 : return "Livraison en cours";
    case 3 : return "Livraison en cours";
    case 4 : return "Livraison en cours";
    default: return "Livrée";
  }
}


Color getStatusCommandValueColor(StatusCommande statusCommande){

  switch(statusCommande.id){
    case 1 : return Colors.brown;
    case 2 : return Colors.lightGreen;
    case 3 : return Colors.lightGreen;
    case 4 : return Colors.lightGreen;
    default: return Colors.black;
  }
}


bool canCommandBeTracked(StatusCommande statusCommande){

  switch(statusCommande.id){
    case 1 : return false;
    case 2 : return true;
    case 3 : return false;
    case 4 : return true;
    default: return false;
  }
}