import 'package:flutter/material.dart';
import 'SignInUpScreen.dart';
import 'Utils/AppSharedPreferences.dart';
import 'package:client_app/Login/SignInPhoneScreen.dart';
import 'HomeScreen.dart';


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
          return SignInUpScreen();
        }));

      }else{

        Navigator.pushReplacement(context, new MaterialPageRoute(builder: (BuildContext context) {
          return SignInPhoneScreen();
        }));

      }

    }, onError: (e){

      Navigator.pushReplacement(context, new MaterialPageRoute(builder: (BuildContext context) {
        return SignInUpScreen();
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
    home: SplashScreen(duration: Duration(seconds: 3)),
  ));
}

