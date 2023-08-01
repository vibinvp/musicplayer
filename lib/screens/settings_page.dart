import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/Controller/Getx_Controller.dart';
import 'package:music_player/screens/custum/snackbar.dart';
import 'package:share_plus/share_plus.dart';

//bool notification = true;

// ignore: camel_case_types
class settings extends StatelessWidget {
   const settings({Key? key}) : super(key: key);

  // ignore: camel_case_types

 
 // bool _toggled = false;

  // @override
  // void initState() {
  //   super.initState();
  //   getSwitchValues();
  // }
  


//   getSwitchValues() async {
//     _toggled = await getSwitchState();
//  //   setState(() {});
//   }

  // Future<bool> saveSwitchState(bool value) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setBool("notification", value);
  //   return prefs.setBool("notification", value);
  // }

  // Future<bool> getSwitchState() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   bool? _toggled = prefs.getBool("notification");

  //   return _toggled ?? true;
  // }

  @override
  Widget build(BuildContext context) {
 final _controller = Get.put(Controller());
 _controller.getSwitchValues();

    
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 2, 36, 41),
      appBar: AppBar(
        elevation: 0,
        title: const Text('Settings'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 2, 36, 41),
      ),
      // ignore: sized_box_for_whitespace
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(35),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30), bottomRight: Radius.circular(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    stops: [
                      0.1,
                      0.4,
                      0.9,
                      0.9,
                    ],
                    colors: [
                      Color.fromARGB(255, 2, 36, 41),
                      Color.fromARGB(255, 3, 37, 43),
                      Color.fromARGB(255, 11, 49, 49),
                     Color.fromARGB(255, 2, 36, 41),
                    ],
                  )),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextButton.icon(
                            onPressed: () {
                              _aboutUs(context);
                            },
                            icon: const Icon(
                              Icons.person_outlined,
                              size: 30,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'About me',
                              style:
                                  TextStyle(fontSize: 19, color: Colors.white),
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton.icon(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.notifications_outlined,
                                  size: 30,
                                  color: Colors.white,
                                ),
                                label: const Text(
                                  'Notification',
                                  style: TextStyle(
                                      fontSize: 19, color: Colors.white),
                                )),
                            GetBuilder<Controller>(
                              builder: (Controller) {
                                return Switch.adaptive(
                                    inactiveThumbColor: const Color.fromARGB(
                                        255, 196, 214, 210),
                                    activeColor:
                                        const Color.fromARGB(255, 12, 86, 51),
                                    value:_controller. toggled,
                                    onChanged: (bool value) {
                                     
                                      _controller. toggled = value;
                                      _controller.update();
                                    _controller.  saveSwitchState(value);
                                   
                                      snackbarcustom(text: 'RESTART YOUR APP');
                                    });
                              },
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextButton.icon(
                            onPressed: () {
                              _shareApp(context);
                            },
                            icon: const Icon(
                              Icons.share,
                              size: 30,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'Share',
                              style:
                                  TextStyle(fontSize: 19, color: Colors.white),
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                        TextButton.icon(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.report_problem,
                              size: 30,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'License',
                              style:
                                  TextStyle(fontSize: 19, color: Colors.white),
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                        TextButton.icon(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.security,
                              size: 30,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'PrivacyPolicy',
                              style:
                                  TextStyle(fontSize: 19, color: Colors.white),
                            ))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _aboutUs(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: Colors.black,
          title: Center(
            child: Text('About me'),
          ),
          content: Padding(
            padding: EdgeInsets.only(bottom: 10, top: 10.0),
            child: Text(
              'Hi I am Ajmal Arsh vp  a Flutter developer https://ajmalarshvp.github.io/portfolio/',
              style: TextStyle(color: Color.fromARGB(255, 240, 237, 235)),
            ),
          ),
        );
      },
    );
  }

  void _shareApp(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;
    const String uri =
        'https://play.google.com/store/apps/details?id=in.brototype.muzeeco';
    await Share.share(
        '''Hey, I'm sharing this music application which helps you to play wonderful musics. please download it!!!
$uri''',
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
        subject: "Sharing the #1 music application");
  }
}
