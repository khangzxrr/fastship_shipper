import 'package:fastship_shipper/views/login.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            constraints: const BoxConstraints.expand(),
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/container.jpeg'),
                    fit: BoxFit.cover)),
            child: InkWell(
                onTap: () {
                  print('tap ');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                },
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                        Colors.black.withOpacity(.9),
                        Colors.black.withOpacity(.0)
                      ])),
                  child: const WelcomeText(),
                ))));
  }
}

class WelcomeText extends StatelessWidget {
  const WelcomeText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final bigTextStyle = TextStyle(
        fontFamily: 'Flicker',
        fontSize: theme.textTheme.displayLarge!.fontSize,
        color: Colors.white);

    final captionStyle = theme.textTheme.displayMedium!
        .copyWith(fontWeight: FontWeight.bold, color: Colors.white);

    final smallTextStyle = theme.textTheme.bodyMedium!
        .copyWith(color: theme.colorScheme.onPrimary);

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Welcome to', style: captionStyle),
          const SizedBox(height: 20),
          Text('Fastship shipper', style: bigTextStyle),
          const SizedBox(height: 20),
          Text('Fast and reliable order and ship service',
              style: smallTextStyle),
          const SizedBox(height: 10)
        ],
      ),
    );
  }
}
