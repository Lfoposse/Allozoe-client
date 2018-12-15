import 'dart:ui';
import 'package:flutter/material.dart';
import '../Models/StatusCommande.dart';
import '../Models/Commande.dart';


/**
 * Les statuts en paramètre sont des entiers
    1: PENDING    Commande enregistree
    2: APPROVED   Commande approuvee par le restaurant
    3: DECLINED   Commande rejetee par le restaurant
    4: SHIPPED    Commande livree
    5: PAID       Commande payee
    6: SHIPPING   En cours de livraison
    7: PREPARING  En cours de preparation
 */


String getStatusCommandValue(StatusCommande statusCommande){

  switch(statusCommande.id){
    case 1 : return "Enregistrée";
    case 2 : return "Approuvée";
    case 3 : return "Rejetée";
    case 4 : return "Livrée";
    case 5 : return "Payée";
    case 6 : return "Livraison en cours";
    case 7 : return "Préparation en cours";
    default: return "Inconnue";
  }
}


Color getStatusCommandValueColor(StatusCommande statusCommande){

  switch(statusCommande.id){
    case 1 : return Colors.brown;
    case 2 : return Colors.brown;
    case 3 : return Colors.red;
    case 4 : return Colors.lightGreen;
    case 5 : return Colors.brown;
    case 6 : return Colors.brown;
    case 7 : return Colors.brown;
    default: return Colors.redAccent;
  }
}


bool canCommandBeTracked(StatusCommande statusCommande){

  switch(statusCommande.id){
    case 1 : return false;
    case 2 : return true;
    case 3 : return false;
    case 4 : return true;
    case 5 : return true;
    case 6 : return true;
    case 7 : return true;
    default: return false;
  }
}


bool isDelivredAndNotRated(Commande commande){

  switch(commande.status.id){
    case 1 : return false;
    case 2 : return false;
    case 3 : return false;
    case 4 : return true && !commande.dejaNoter;
    case 5 : return false;
    case 6 : return false;
    case 7 : return false;
    default: return false;
  }
}

