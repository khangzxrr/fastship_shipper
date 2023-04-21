
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {

const LoginScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login screen'),
      ),
      body: const LoginScreenInfo(),
    );
  }

}

class LoginScreenInfo extends StatelessWidget {
  const LoginScreenInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    final welcomeTextStyle = theme.textTheme.displayMedium!;

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          Text('Please login to your account', style: welcomeTextStyle),
          const SizedBox(height: 40),
          Column(
            children: [
            const TextField(
              decoration: InputDecoration(
                labelText: 'Email'
              )
            ),
            const SizedBox(height: 15),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password'
              ),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: (){
                print('loggin pressed');
              },
              child: const Text('Login',)
            )
          ],)
        ],
      ),
    );
  }
}