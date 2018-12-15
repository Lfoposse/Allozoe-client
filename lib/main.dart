import 'package:flutter/material.dart';
import 'Utils/AppSharedPreferences.dart';
import 'SignInScreen.dart';
import 'HomeScreen.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'translations.dart';


class SplashScreen extends StatefulWidget {
  final Duration duration;

  const SplashScreen({this.duration});

  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;

  void goToAuthentification(){ // lance l'espace d'authentification

    AppSharedPreferences().isAppFirstLaunch().then((bool isFirstLaunch){
      if(isFirstLaunch){

        AppSharedPreferences().setAppFirstLaunch(false);
        Navigator.pushReplacement(context, new MaterialPageRoute(builder: (BuildContext context) {
          return SignInScreen();
        }));

      }else{

        Navigator.pushReplacement(context, new MaterialPageRoute(builder: (BuildContext context) {
          return SignInScreen();
        }));

      }

    }, onError: (e){

      Navigator.pushReplacement(context, new MaterialPageRoute(builder: (BuildContext context) {
        return SignInScreen();
      }));

    });
  }

  @override
  void initState() {
    animationController =
        new AnimationController(duration: widget.duration, vsync: this)
          ..forward()
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {

              AppSharedPreferences().isAppLoggedIn().then((bool is_logged){

                if(is_logged){ // on va direct a la page d'accueil

                  Navigator.pushReplacement(context, new MaterialPageRoute(builder: (BuildContext context) {
                    return HomeScreen();
                  }));

                }else{
                  goToAuthentification();
                }
              },
                  onError: (e){
                    goToAuthentification();
                  }
              );

            }
          });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new AnimatedBuilder(
      animation: animationController,
      builder: (context, _) {
        return Material(
          child: Image.asset(
            'images/splash_bgd.jpg',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          )
        );
      },
    );
  }

}

void main() {
  runApp(MaterialApp(
      localizationsDelegates: [
        const TranslationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''),
        const Locale('fr', ''),
      ],
    home: SplashScreen(duration: Duration(seconds: 3)),
  ));
}

