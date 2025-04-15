import 'package:flutter/material.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Video Player"),
      ),
      body: ListView.builder(
        itemCount: 10,
          itemBuilder: (context,index){
          return Padding(
            padding: EdgeInsets.all(15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height:70,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Icon(Icons.play_arrow,color: Colors.white,),
                ),
                SizedBox(width: 20,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Video Title ${index+1}",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                      Text("Video SubTitle ${index+1}",style: TextStyle(fontSize: 16,),)
                    ],
                  ),
                ),
                Icon(Icons.more_vert)
              ],
            ),
          );

      }),

    );
  }
}
