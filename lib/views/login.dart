import 'package:fastship_shipper/libs/authorizeClient.dart';
import 'package:fastship_shipper/providers/login.dart';
import 'package:fastship_shipper/views/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

    return Consumer<LoginProvider>(
      builder: (context, loginProvider, child) {
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Text('Please login to your account', style: welcomeTextStyle),
              const SizedBox(height: 40),
              Column(
                children: [
                  TextField(
                      decoration: const InputDecoration(labelText: 'Email'),
                      onChanged: (value) {
                        loginProvider.setEmail(value);
                      }),
                  const SizedBox(height: 15),
                  TextField(
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password'),
                    onChanged: (value) {
                      loginProvider.setPassword(value);
                    },
                  ),
                  const SizedBox(height: 50),
                  Container(
                      width: double.infinity,
                      child: FilledButton(
                          onPressed: () {
                            loginProvider.login(() {
                              if (loginProvider.loginModel.token.isNotEmpty) {
                                print('login success');

                                AuthorizeClient.sharedPreferences.setString(
                                    'token', loginProvider.loginModel.token);

                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => MyHomePage()));
                              }
                            });
                          },
                          child: const Text(
                            'Login to shipper account',
                          ))),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
