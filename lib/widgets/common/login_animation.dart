import 'package:flutter/material.dart';

import '../../generated/l10n.dart';

class StaggerAnimation extends StatelessWidget {
  final VoidCallback? onTap;
  final String titleButton;

  StaggerAnimation({
    Key? key,
    required this.buttonController,
    this.onTap,
    this.titleButton = 'Sign In',
  })  : buttonSqueezeanimation = Tween(
          begin: 320.0,
          end: 50.0,
        ).animate(
          CurvedAnimation(
            parent: buttonController,
            curve: const Interval(
              0.0,
              0.150,
            ),
          ),
        ),
        containerCircleAnimation = EdgeInsetsTween(
          begin: const EdgeInsets.only(bottom: 30.0),
          end: const EdgeInsets.only(bottom: 0.0),
        ).animate(
          CurvedAnimation(
            parent: buttonController,
            curve: const Interval(
              0.500,
              0.800,
              curve: Curves.ease,
            ),
          ),
        ),
        super(key: key);

  final AnimationController buttonController;
  final Animation<EdgeInsets> containerCircleAnimation;
  final Animation buttonSqueezeanimation;

  Widget _buildAnimation(BuildContext context, Widget? child) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: buttonSqueezeanimation.value,
        height: 50,
        alignment: FractionalOffset.center,
        decoration: BoxDecoration(
            // color: Theme.of(context).primaryColor,
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(25.0)),
            border: Border.all(color: Colors.grey.shade500, width: 1)),
        child: buttonSqueezeanimation.value > 75.0
            ? Text(
                S.of(context).signIn,
                style: TextStyle(
                  // color: Colors.white,
                  color: Theme.of(context).primaryColor,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 0.3,
                ),
              )
            : CircularProgressIndicator(
                value: null,
                strokeWidth: 1.0,
                // valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: buttonController,
    );
  }
}
