import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weight_finance/global_api.dart';
import 'package:weight_finance/data/asset.dart';

class BankLogoAssets implements Assets<Widget> {
  String _version = "";
  final String _s3JsonUrl = 'https://weight500-finance.s3.ap-northeast-2.amazonaws.com/bank_logo.json';

  String get version => _version;

  // final Map<String, String> _logoMap = {
  //   '0010001': 'woori.png',
  //   '0010002': 'sc.png',
  //   '0010016': 'imbank.png',
  //   '0010017': 'bnk.png',
  //   '0010019': 'knj.png',
  //   '0010020': 'shinhan.png',
  //   '0010022': 'knj.png',
  //   '0010024': 'bnk-kyongnam.png',
  //   '0010026': 'IBK.svg',
  //   '0010030': 'KDB.svg',
  //   '0010927': 'kb.png',
  //   '0011625': 'shinhan.png',
  //   '0013175': 'nj.png',
  //   '0013909': 'keb.png',
  //   '0014807': 'suhyup.png',
  //   '0015130': 'kakaobank.png',
  //   '0017801': 'toss.png',
  //   '0010345': 'acuon.png',
  //   '0010346': 'osb.png',
  //   '0010349': 'db.png',
  //   '0010350': 'sky.png',
  //   '0010354': 'minkuk.png',
  //   '0010356': 'pureun.png',
  //   '0010358': 'hb.png',
  //   '0010359': 'kiwoomyes.png',
  //   '0010363': 'thek.png',
  //   '0010366': 'choeun.png',
  //   '0010370': 'sbi.png',
  //   '0010378': 'baro.png',
  //   '0010388': 'daol.png',
  //   '0010389': 'uanta.png',
  //   '0010390': 'heungkuk.png',
  //   '0010391': 'kukje.png',
  //   '0010404': 'dh.png',
  //   '0010416': 'stx.png',
  //   '0010418': 'woolee-saving-bank.png',
  //   '0010419': 'insung.png',
  //   '0010421': 'kuemhwa.png',
  //   '0010426': 'incheon.png',
  //   '0010430': 'moa.png',
  //   '0010438': 'union.png',
  //   '0010439': 'ms.png',
  //   '0010453': 'bulim.png',
  //   '0010456': 'kiwoombank.png',
  //   '0010457': 'samjung.png',
  //   '0010460': 'pyeongtaek.png',
  //   '0010463': 'anyang.png',
  //   '0010464': 'youngjin.png',
  //   '0010467': 'yungchang.png',
  //   '0010467': 'yungchang.png',
  //   '0010468': 'seram.png',
  //   '0010471': 'pepper.png',
  //   '0010473': 'sangsangin.png',
  //   '0010477': 'hanhwa.png',
  //   '0010478': 'ck.png',
  //   '0010485': 'daemyung.png',
  //   '0010488': 'woori.png',
  //   '0010489': 'cheongju.png',
  //   '0010492': 'hansung.png',
  //   '0010508': 'sangsanginplus.png',
  //   '0010509': 'asan.png',
  //   '0010510': 'o2.png',
  //   '0010521': 'star.png',
  //   '0010526': 'daehan.png',
  //   '0010527': 'dongyang.png',
  //   '0010528': 'double.png',
  //   '0010533': 'central.png',
  //   '0010534': 'smartbank.png',
  //   '0010537': 'hankuk.png',
  //   '0010550': 'raon.png',
  //   '0010551': 'dream.png',
  //   '0010553': 'daea.png',
  //   '0010556': 'mustsamil.png',
  //   '0010560': 'charm.png',
  //   '0010562': 'osung.png',
  //   '0010568': 'daea.png',
  //   '0010569': 'snt.png',
  //   '0010572': 'soulbrain.png',
  //   '0010574': 'dongwon.png',
  //   '0010575': 'choheung.png',
  //   '0010576': 'jinju.png',
  //   '0011551': 'heungkuk.png',
  //   '0011767': 'jtbank.png',
  //   '0012120': 'samho.png',
  //   '0012711': 'nh.png',
  //   '0012840': 'daeshin.png',
  //   '0012889': 'ibk.png',
  //   '0013002': 'bnk.png',
  //   '0013127': 'kb-savings.png',
  //   '0013166': 'keb.png',
  //   '0013308': 'jt.png',
  //   '0013313': 'shinhan.png',
  //   '0013350': 'welcome.png',
  //   '0013351': 'ok.png',
  // };

  Map<String, String> _logoMap = {};

  @override
  Future<void> init() async {
    await _loadLogoMap();
  }

  @override
  String get basepath => "assets/images/bank_logos/";

  @override
  Widget getAsset(String key, {Map<String, dynamic>? params}) {
    double size = params?['size'] as double? ?? 24;
    final String? fileName = _logoMap[key];
    if (fileName != null) {
      if (fileName.toLowerCase().endsWith('.svg')) {
        return SvgPicture.asset(
          basepath + fileName,
          width: size,
          height: size,
          placeholderBuilder: (BuildContext context) => _defaultIcon(size),
        );
      } else {
        return Image.asset(
          basepath + fileName,
          width: size,
          height: size,
          errorBuilder: (context, error, stackTrace) {
            return _defaultIcon(size);
          },
        );
      }
    } else {
      return _defaultIcon(size);
    }
  }

  Widget _defaultIcon(double size) {
    return Icon(Icons.account_balance, size: size, color: Colors.blue);
  }

  Future<void> forceUpdate() async {
    await _loadLogoMap();
  }

  Future<void> _loadLogoMap() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedJson = prefs.getString('bank_logo_mapping');

      if (cachedJson != null) {
        final cachedData = json.decode(cachedJson);
        _logoMap = Map<String, String>.from(cachedData['logos']);
        _version = cachedData['version'];
      }

      final response = await http.get(Uri.parse(_s3JsonUrl));
      if (response.statusCode == 200) {
        final fetchedData = json.decode(response.body);
        final fetchedVersion = fetchedData['version'];

        if (fetchedVersion != _version) {
          _logoMap = Map<String, String>.from(fetchedData['logos']);
          _version = fetchedVersion;
          await prefs.setString('bank_logo_mapping', response.body);
        }
      }
    } catch (e) {
      GlobalAPI.logger.d('Error loading logo map: $e');
    }
  }
}
