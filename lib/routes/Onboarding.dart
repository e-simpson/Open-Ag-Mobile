import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:open_ag_mobile/components/ImageAndTitle.dart';
//import 'package:flutter_swiper/flutter_swiper.dart';
//import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'package:open_ag_mobile/routes/Setup.dart';


class Onboarding extends StatefulWidget {
  @override
  OnboardingState createState() => OnboardingState();
}

class OnboardingState extends State<Onboarding> {
  int _index = 0;
  PageController pageController = PageController();

  List<Widget> carouselItems = <Widget>[
    ImageAndTitle(image: "assets/agriculture.png", title: "Experience a new way to grow"),
    ImageAndTitle(image: "assets/research.png", title: "Contribute to a world class\nresearch project"),
    ImageAndTitle(image: "assets/crops.png", title: "Enjoy what you have grown")
  ];

  void enterSetupProcess(){
    Navigator.of(context).push(CupertinoPageRoute<bool>(builder: (context) => Setup()));
  }

  Widget createIndicator() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List < Widget>.generate(carouselItems.length, (int i) {
          return Container(
            width: 8.0,
            height: 8.0,
            margin: EdgeInsets.symmetric(horizontal: 2.0),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i == _index ? Color.fromRGBO(0, 0, 0, 0.8) : Color.fromRGBO(0, 0, 0, 0.2)
            ),
          );
        })
    );
  }

  @override
  Widget build(BuildContext context) {

    Widget logoAndTitle = Container(
        child: Column( children: <Widget>[
          Padding(
            padding: const EdgeInsets.only( bottom: 8.0),
            child: Icon(Icons.nature, size: 40.0),
          ),
          Text("OpenAg Mobile",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)
          )
        ],
        )
    );

//    Widget car = Swiper(
//      itemBuilder: (BuildContext context,int i){ return carouselItems[i]; },
//      itemCount: 3,
//      itemWidth: 250.0,
//      pagination: SwiperPagination(),
//      control: SwiperControl(),
//      autoplay: true,
//      autoplayDelay: 4,
//      autoplayDisableOnInteraction: true,
////      indicatorLayout: PageIndicatorLayout.WARM,
//    );

    Widget carousel = Stack(
      alignment: Alignment.center,
      children: <Widget>[
        CarouselSlider(
          autoPlay: true,
          distortion: true,
          interval: const Duration(seconds: 5),
          height: 400.0,
          items: carouselItems,
          updateCallback: (index) {setState(() {_index = index;});},
        ),
        Positioned(bottom: 40.0, child: createIndicator())
      ],
    );


    Widget setupButton = CupertinoButton(
      child: Text("Set up a Food Computer"),
      onPressed: enterSetupProcess,
      color: Theme.of(context).primaryColor,
    );

    Widget body = Padding(
      padding: const EdgeInsets.only( top: 26.0, bottom: 26.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          logoAndTitle,
          carousel,
          setupButton
        ],
      )
    );

    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Center(child: body)
    );
  }
}