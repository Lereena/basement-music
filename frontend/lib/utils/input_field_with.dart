import 'dart:math';

import 'package:flutter/material.dart';

double inputFieldWidth(BuildContext context) => min(MediaQuery.of(context).size.width / 1.5, 400).toDouble();
