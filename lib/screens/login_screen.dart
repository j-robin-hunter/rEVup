import 'package:flutter/material.dart';
import 'package:revup/forms/login_form.dart';
import 'package:revup/widgets/copyright.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 110.0,
              color: Theme.of(context).appBarTheme.backgroundColor,
            ),
            Positioned(
              left: 0,
              top: 0,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  width: 150.0,
                  height: 86.0,
                  child: Image.asset('lib/assets/images/logo-rev-230x132.png'),
                ),
              ),
            ),
            Positioned(
              top: 35.0,
              right: 10.0,
              child: SizedBox(
                height: 35.0,
                child: IconButton(
                  mouseCursor: SystemMouseCursors.click,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                ),
                child: Card(
                  elevation: 10,
                  child: Container(
                    height: 400.0,
                    constraints: const BoxConstraints(
                      minWidth: 400,
                      maxWidth: 800,
                    ),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(3.0),
                      ),
                      image: DecorationImage(
                        image: AssetImage('lib/assets/images/earth.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    alignment: Alignment.centerLeft,
                    // align your child's position.
                    child: const Padding(
                      padding: EdgeInsets.only(left: 50.0),
                      child: SizedBox(
                        width: 294.0,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                          child: LoginForm(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Positioned(
              left: 0,
              bottom: 0,
              right: 0,
              child: Copyright(),
            ),
          ],
        ),
      ),
    );
  }
}
