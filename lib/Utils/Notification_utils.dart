import 'package:client_app/DAO/Presenters/CmdHistoryNotifPresenter.dart';
import 'package:client_app/Database/DatabaseHelper.dart';
import 'package:client_app/Models/Client.dart';
import 'package:client_app/Models/Commande.dart';
import 'package:client_app/Models/CommandeNotif.dart';
import 'package:client_app/Notation.dart';
import 'package:client_app/StringKeys.dart';
import 'package:client_app/Utils/CommandStatusHelper.dart';
import 'package:client_app/Utils/PriceFormatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationUtil extends StatefulWidget {
  BuildContext context;
  CommandeHistoryNotifPresenter _presenter;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  Commande cmdsToSend;
  bool etat1 = false;
  bool etat2 = false;
  init(BuildContext context) {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
    this.context = context;

    notification();
  }

  //  Action a effectuer lorsqu'on clique sur la notification
  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('Cmd to send at the next page' + payload);
    }
    await showDialog(
      context: context,
      builder: (BuildContext contex) {
        return new AlertDialog(
          title: Text('La commande N :' + this.cmdsToSend.reference,
              style: new TextStyle(
                color: Colors.blue[900],
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              )),
          content: Container(
            width: double.maxFinite,
            height: 120.0,
            child: Column(
              children: <Widget>[
                Text(
                    " de " +
                        PriceFormatter.formatPrice(price: this.cmdsToSend.prix),
                    textAlign: TextAlign.left,
                    style: new TextStyle(
                      color: Colors.black,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.bold,
                    )),
                Text(" passée le " + this.cmdsToSend.date,
                    textAlign: TextAlign.left,
                    style: new TextStyle(
                      color: Colors.black87,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.bold,
                    )),
                Text(" à " + this.cmdsToSend.heure,
                    textAlign: TextAlign.left,
                    style: new TextStyle(
                      color: Colors.black87,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.bold,
                    )),
                this.etat1
                    ? (this.etat2
                        ? Text(
                            "a été livrée \n",
                            maxLines: 1,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.lightGreen,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : Text(
                            "En cour de Livraison \n",
                            maxLines: 1,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ))
                    : Text(
                        " a été validée ",
                        maxLines: 1,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.orangeAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                new Divider(
                  height: 5,
                ),
                isDelivredAndNotRated(this.cmdsToSend)
                    ? new InkWell(
                        child: Container(
                          margin: EdgeInsets.only(right: 5.0),
                          padding: EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            color: Colors.lightGreen,
                          ),
                          child: Text(
                            getLocaleText(
                                context: context,
                                strinKey: StringKeys.COMMANDE_NOTE),
                            style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        onTap: () {
                          showRatingDialog(context, this.cmdsToSend);
                        },
                      )
                    : Container(),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  /// Active la notification avec sound customiser cmd valide
  Future _showNotificationWithSound() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        icon: '@mipmap/launcher_icon',
        sound: 'notification',
        importance: Importance.Max,
        priority: Priority.High);
    var iOSPlatformChannelSpecifics =
        new IOSNotificationDetails(sound: "slow_spring_board.aiff");
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'AlloZoe',
      'Commande validée',
      platformChannelSpecifics,
      payload: 'Custom_Sound',
    );
  }

  /// Active la notification avec sound customiser en cr livraison
  Future _showNotificationWithSoundEl() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        icon: '@mipmap/launcher_icon',
        sound: 'notification',
        importance: Importance.Max,
        priority: Priority.High);
    var iOSPlatformChannelSpecifics =
        new IOSNotificationDetails(sound: "slow_spring_board.aiff");
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'AlloZoe',
      'Commande en cour de livraison',
      platformChannelSpecifics,
      payload: 'Custom_Sound',
    );
  }

  /// Active la notification avec sound customiser en cr livraison
  Future _showNotificationWithSoundCmdLV() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        icon: '@mipmap/launcher_icon',
        sound: 'notification',
        importance: Importance.Max,
        priority: Priority.High);
    var iOSPlatformChannelSpecifics =
        new IOSNotificationDetails(sound: "slow_spring_board.aiff");
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'AlloZoe',
      'Commande livrée',
      platformChannelSpecifics,
      payload: 'Custom_Sound',
    );
  }

  notification() {
    _presenter = new CommandeHistoryNotifPresenter();

    new DatabaseHelper().loadClient().then((Client c) {
      if (c == null)
        return null;
      else {
        ///       liste les commandes validees du client
        _presenter.loadCmdsValide(c.id).then((List<Commande> cmds) {
          if (cmds != null && cmds.length > 0) {
            print("Cmd Valide" + cmds.toString());
            new DatabaseHelper().loadCmdVa().then((List<CommandeNotif> notifs) {
              ///             si la bd locale est vide
              print("table size");
              print(notifs.length);
              if (notifs.length == 0) {
                this.etat1 = false;
                for (int i = 0; i < cmds.length; i++) {
                  this.cmdsToSend = cmds[i];
                  new DatabaseHelper().saveCmdVa(cmds[i]);
                  _showNotificationWithSound();
                }
              }

//              ///                Si le nbr de cmd valide sur le serveur est diff de celui en local on vide puis on charge
//            } else if (cmds.length != notifs.length) {
//              ///               vide la table avant d'ajouter
//              this.etat = true;
//              this.cmdsToSend.clear();
//              new DatabaseHelper().clearCmdValide();
//              for (int i = 0; i < cmds.length; i++) {
//                this.cmdsToSend.add(cmds[i]);
//                new DatabaseHelper().saveCmdVa(cmds[i]);
//                _showNotificationWithSound();
//              }
//            }
            });
          }
        });

        ///       liste les commandes en cour de livraison du client
        new DatabaseHelper().loadCmdVa().then((List<CommandeNotif> notifs) {
          if (notifs.length == 0) {
            print('Aucune cmd valide');
          } else {
            for (int i = 0; i < notifs.length; i++) {
              _presenter
                  .loadCmdDetail(notifs[i].commande_id)
                  .then((Commande cmd) {
                if (cmd.status.id == 8) {
                  this.etat1 = true;
                  this.etat2 = false;
                  new DatabaseHelper().clearCmdValide();
                  print("cmd en cl" + cmd.toString());
                  this.cmdsToSend = cmd;
                  new DatabaseHelper().saveCmdEL(cmd);
                  _showNotificationWithSoundEl();
                }
              });
            }
          }
        });

//        _presenter.loadCmdsLivraison(c.id).then((List<Commande> cmds) {
//          if (cmds != null && cmds.length > 0) {
//            print("CmdValide" + cmds.toString());
//            new DatabaseHelper().loadCmdEL().then((List<CommandeShipp> notifs) {
////              si la bd locale est vide
//              print("EL table size");
//              print(notifs.length);
//              if (notifs.length == 0) {
//                this.etat = false;
//                this.cmdsToSend.clear();
//                for (int i = 0; i < cmds.length; i++) {
//                  cmdsToSend.add(cmds[i]);
//                  new DatabaseHelper().saveCmdEL(cmds[i]);
//                  _showNotificationWithSoundEl();
//                }
//
//                ///                 Si le nbr de cmd valide sur le serveur est diff de celui en local on vide puis on charge
//              } else if (cmds.length != notifs.length) {
//                ///                vide la table avant d'ajouter
//                this.etat = false;
//                this.cmdsToSend.clear();
//                new DatabaseHelper().clearCmdEL();
//                for (int i = 0; i < cmds.length; i++) {
//                  this.cmdsToSend.add(cmds[i]);
//                  new DatabaseHelper().saveCmdEL(cmds[i]);
//                  _showNotificationWithSoundEl();
//                }
//              }
//            });
//          }
//        });

        ///        Cmd livees
        new DatabaseHelper().loadCmdEL().then((List<CommandeShipp> notifs) {
          if (notifs.length == 0) {
            print('Aucune cmd en cl');
          } else {
            for (int i = 0; i < notifs.length; i++) {
              _presenter
                  .loadCmdDetail(notifs[i].commande_id)
                  .then((Commande cmd) {
                if (cmd.status.id == 4) {
                  this.etat1 = true;
                  this.etat2 = true;
                  print("cmd livre" + cmd.toString());
                  this.cmdsToSend = cmd;
                  new DatabaseHelper().clearCmdEL();
                  _showNotificationWithSoundCmdLV();
                }
              });
            }
          }
        });
      }
    });
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return null;
  }
}
