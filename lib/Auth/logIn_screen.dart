import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:yumfood/Auth/service_helper.dart';
import 'package:yumfood/UI/dashboard.dart';
import 'package:yumfood/model.dart';
import 'package:yumfood/resources.dart/data_generator.dart';
import 'package:yumfood/resources.dart/widgets.dart';


class FoodCreateAccount extends StatefulWidget {
  static String tag = '/FoodCreateAccount';

  @override
  FoodCreateAccountState createState() => FoodCreateAccountState();
}

class FoodCreateAccountState extends State<FoodCreateAccount> {
  late List<images> mList;

  TextEditingController inputController = TextEditingController();
  TextEditingController passwordController =TextEditingController();
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    mList = addUserPhotosData();

    setState(() {});
  }
  


  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: width,
                alignment: Alignment.topLeft,
                
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    finish(context);
                  },
                ),
              ),
              SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Create your account', style: boldTextStyle(size: 24), maxLines: 2),
                  Text('It\'s super Quick', style: primaryTextStyle()),
                ],
              ).paddingOnly(left: 16, right: 16),
              SizedBox(height: 30.0),
              SizedBox(
                height: width * 0.2,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: mList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(left: 16),
                      child: CircleAvatar(backgroundImage: CachedNetworkImageProvider(mList[index].image), radius: 45),
                    );
                  },
                ),
              ),
              SizedBox(height: 24),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    TextField(
                      controller: inputController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: "Enter email Id",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                    SizedBox(height: 10,),
                    TextField(
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        hintText: "Enter your Password",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                  ],
                ),
              ),SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [TextButton(
                onPressed: () {
                  CreateAnAccount().launch(context);
                }, 
                child: Text('Create an Account')),

                         Expanded(
                          child: GestureDetector(
                            onTap:()async{
                            await AuthServiceHelper.loginWithEmail(inputController.text,passwordController.text).then((value){
                          if(value =='Login Successful.'){
                            
                              Navigator.pushReplacement( context, MaterialPageRoute(builder: (context) => FoodDashboard()),);
                              } else{
                                 Message.show(message: "Error:$value");
                                            }
                              
                            });},
                            child: Container(
                              padding: EdgeInsets.all(14.0),
                              decoration: gradientBoxDecoration(radius: 50, gradientColor1: Color(0xFF398CE8), gradientColor2: Color(0xFF3F77DE)),
                              child: Icon(Icons.arrow_forward, color: Colors.white),
                            ),
                          ),
                        ),
                      ]
                    )
                  ],
                ),
              )
            
          ));
        
      
    
  }
  
}
class CreateAnAccount extends StatefulWidget {
  const CreateAnAccount({super.key});

  @override
  State<CreateAnAccount> createState() => _CreateAnAccountState();
}

class _CreateAnAccountState extends State<CreateAnAccount> {
  TextEditingController inputController =TextEditingController();
  TextEditingController passwordController =TextEditingController();


 Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('SignUp',style: TextStyle(fontWeight: FontWeight.w800,fontSize: 30),),
            SizedBox(height: 10,),
            TextFormField(
              controller: inputController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                label: Text("Email Id"),
                hintText: 'Enter your Email Id.',
              ),
            ),
             SizedBox(height: 10,),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                label: Text("Password"),
                hintText: 'Enter your Password',
              ),
            ),
            SizedBox(height: 10,),
            SizedBox(width: double.infinity,
            height: 45,
            child: OutlinedButton(
              onPressed: ()async{
                
                await AuthServiceHelper.createAccountWithEmail(inputController.text,passwordController.text).then((value){
                  if(value =="Account Created"){
 
                    FoodDashboard().launch(context);
                  }else{
                    setState(() {
                      
                       Message.show(message: "Error:$value");
                         });
                  }
                
                });
              },

            child: Text('Sign Up')),),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Already have an Account'),
                TextButton(
                  
                  onPressed: (){
                  Navigator.pop(context);
                  }, 
                  child: Text('LogIn')),
              ],
            )




          ],
        ),),
      ),
    );
}}
