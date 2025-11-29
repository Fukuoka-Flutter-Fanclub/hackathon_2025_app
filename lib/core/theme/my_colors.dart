import 'package:flutter/material.dart';

enum MyColors {
  // white
  white(color: Color(0xffffffff)),
  // gray
  gray100(color: Color(0xffF5F5F5)), // 追加：surfaceVariant用の薄いグレー
  grayCD(color: Color(0xffCDCDCD)),
  gray300(color: Color(0xffECEDF3)),
  // red
  red(color: Color(0xffff0000)),
  // black
  black(color: Color(0xff080808)), // 半透明等で利用
  black600(color: Color(0xff434343)),
  black700(color: Color(0xff303030)), // 追加：ダークモード用のsurfaceVariant
  black900(color: Color(0xff1C1C1C)),
  black1000(color: Color(0xff0C0C0C)),
  // Turquoise theme colors
  turquoiseLight(color: Color(0xff20B2AA)), // ライトシーグリーン - ライトモードのメイン
  turquoiseMedium(color: Color(0xff00CED1)), // ダークターコイズ - 中間色
  turquoiseDark(color: Color(0xff008B8B)), // ダークシアン - ダークモードのメイン
  turquoiseBright(color: Color(0xff40E0D0)), // 明るいターコイズ - アクセント用
  // primary (メインのターコイズカラー)
  primaryMain(color: Color(0xff20B2AA)), // ライトシーグリーン
  primaryDark(color: Color(0xff008B8B)), // ダークシアン
  // secondary
  secondaryMain(color: Color(0xff40E0D0)), // 明るいターコイズ
  ;

  const MyColors({required this.color});
  final Color color;

  static MaterialColor get materialColor =>
      convertSingleMaterialColor(MyColors.primaryMain.color.value);

  static MaterialColor convertSingleMaterialColor(int value) {
    return MaterialColor(
      value,
      <int, Color>{
        50: Color(value),
        100: Color(value),
        200: Color(value),
        300: Color(value),
        400: Color(value),
        500: Color(value),
        600: Color(value),
        700: Color(value),
        800: Color(value),
        900: Color(value),
      },
    );
  }
}
