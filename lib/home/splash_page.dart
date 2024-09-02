
import 'dart:async';

import 'package:deer_imitate/res/constant.dart';
import 'package:deer_imitate/utils/device_utils.dart';
import 'package:deer_imitate/utils/image_utils.dart';
import 'package:deer_imitate/utils/theme_utils.dart';
import 'package:deer_imitate/widgets/fractionally_aligned_sized_box.dart';
import 'package:deer_imitate/widgets/load_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety_flutter3/flutter_swiper_null_safety_flutter3.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sp_util/sp_util.dart';

class SplashPage extends StatefulWidget{
  const SplashPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SplashPageState();
  }

}

class _SplashPageState extends State<SplashPage>{
  int _status = 0;
  final List<String> _guideList = ['app_start_1', 'app_start_2', 'app_start_3'];
  StreamSubscription<dynamic>? _subscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await SpUtil.getInstance();
      await Device.initDeviceInfo();
      if(SpUtil.getBool(Constant.keyGuide,defValue: true)!|| Constant.isDriverTest){
        void precacheImages(String image){
          precacheImage(ImageUtils.getAssetImage(image,format: ImageFormat.webp), context);
        }
        _guideList.forEach(precacheImages);
      }
      _initSplash();
    });
  }
  @override
  Widget build(BuildContext context) {
    print("build status: "+_status.toString());
    return Material(
      color: context.backgroundColor,
      child: _status == 0 ?
      const FractionallyAlignedSizedBox(
        heightFactor: 0.3,
        widthFactor: 0.33,
        leftFactor: 0.33,
        bottomFactor: 0,
        child: LoadAssetImage('logo'),
      ):Swiper(
          itemBuilder: (context,index){
            return LoadAssetImage(
              _guideList[index],
              fit:BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              format: ImageFormat.webp,
            );
          },
          loop: false,
          itemCount: _guideList.length)
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _initGuide(){
    setState(() {
      print("_status = 1");
      _status = 1;
    });
  }

  void _initSplash() {
    print("_initSplash");
    _subscription = Stream.value(1).delay(const Duration(milliseconds: 1500)).listen((_) {
      if (SpUtil.getBool(Constant.keyGuide, defValue: true)! || Constant.isDriverTest) {
        SpUtil.putBool(Constant.keyGuide, false);
        _initGuide();
      } else {

      }
    });
  }

}