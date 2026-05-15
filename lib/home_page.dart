import 'package:flutter/material.dart';
import 'package:Notes/data/local/db_helper.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageSate();
}

class _HomePageSate extends State<HomePage> {

  ///controlers
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  List<Map<String,dynamic>> allNotes = [];
  DBHelper? dbRef;
  String errorMess = "";

  @override
  void initState() {
    super.initState();
    dbRef = DBHelper.getInstance;
    getNotes();
  }

  void getNotes() async {
    allNotes = await dbRef!.getAllNotes();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text('Notes'),
      ),

      ///all notes view here
      body: allNotes.isNotEmpty

          ? ListView.builder(

          itemCount: allNotes.length,

          itemBuilder: (_, index){

            return ListTile(

              leading: Text('${index + 1}'),

              title: Text(
                allNotes[index][DBHelper.COLUMN_NOTE_TITLE],
              ),

              subtitle: Text(
                allNotes[index][DBHelper.COLUMN_NOTE_DESC],
              ),

              trailing: SizedBox(

                width: 50,

                child: Row(

                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [

                    ///EDIT NOTE
                    InkWell(

                      onTap: (){

                        titleController.text =
                        allNotes[index][DBHelper.COLUMN_NOTE_TITLE];

                        descController.text =
                        allNotes[index][DBHelper.COLUMN_NOTE_DESC];

                        showModalBottomSheet(

                            context: context,

                            isScrollControlled: true,

                            builder: (context){

                              return Padding(

                                padding: EdgeInsets.only(
                                  bottom: MediaQuery.of(context).viewInsets.bottom,
                                ),

                                child: getBottonSheetWidget(
                                  isUpdate: true,
                                  sno: allNotes[index][DBHelper.COLUMN_NOTE_SNO],
                                ),
                              );
                            });
                      },

                      child: Icon(Icons.edit),
                    ),

                    ///DELETE NOTE
                    InkWell(

                      onTap: () async {

                        bool check = await dbRef!.deleteNote(
                          sno: allNotes[index][DBHelper.COLUMN_NOTE_SNO],
                        );

                        if(check){
                          getNotes();
                        }
                      },

                      child: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            );
          })

          : Center(
        child: Text('No Notes Yet'),
      ),

      floatingActionButton: FloatingActionButton(

        onPressed: () async {

          titleController.clear();
          descController.clear();

          showModalBottomSheet(

              context: context,

              isScrollControlled: true,

              builder: (context){

                return Padding(

                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),

                  child: getBottonSheetWidget(),
                );
              });
        },

        child: Icon(Icons.add),
      ),
    );
  }

  Widget getBottonSheetWidget({
    bool isUpdate = false,
    int sno = 0,
  }){

    return SingleChildScrollView(

      child: Container(

        padding: EdgeInsets.all(11),
        width: double.infinity,

        child: Column(

          mainAxisSize: MainAxisSize.min,

          children: [

            Text(

              isUpdate ? 'Update Note' : 'Add Note',

              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(
              height: 21,
            ),

            ///Title for the notes
            TextField(

              controller: titleController,

              decoration: InputDecoration(

                hintText: 'Enter Title Here',

                label: Text('Title *'),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
              ),
            ),

            SizedBox(
              height: 11,
            ),

            ///Description for the given title
            TextField(

              controller: descController,
              maxLines: 5,

              decoration: InputDecoration(

                hintText: 'Enter Description',

                label: Text('Descriptions *'),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
              ),
            ),

            SizedBox(
              height: 11,
            ),

            ///ERROR MESSAGE
            Text(

              errorMess,

              style: TextStyle(
                color: Colors.red,
              ),
            ),

            SizedBox(
              height: 11,
            ),

            ///Buttons add and cancel
            Row(

              children: [

                Expanded(

                  child: OutlinedButton(

                    style: OutlinedButton.styleFrom(

                      side: BorderSide(
                        width: 1,
                        color: Colors.black,
                      ),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11),
                      ),
                    ),

                    onPressed: () async {

                      var title = titleController.text;
                      var desc = descController.text;

                      if(title.isNotEmpty && desc.isNotEmpty){

                        bool check = isUpdate

                            ? await dbRef!.updateNote(
                          mtitle: title,
                          mdesc: desc,
                          sno: sno,
                        )

                            : await dbRef!.addNote(
                          mTitle: title,
                          mDesc: desc,
                        );

                        if(check){

                          getNotes();

                          setState(() {
                            errorMess = "";
                          });
                        }

                        titleController.clear();
                        descController.clear();

                        Navigator.pop(context);

                      } else {

                        setState(() {
                          errorMess = "Please fill all the details!";
                        });
                      }
                    },

                    child: Text(
                      isUpdate ? 'Update Note' : 'Add Note',
                    ),
                  ),
                ),

                SizedBox(
                  width: 11,
                ),

                Expanded(

                  child: OutlinedButton(

                    style: OutlinedButton.styleFrom(

                      side: BorderSide(
                        width: 1,
                        color: Colors.black,
                      ),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11),
                      ),
                    ),

                    onPressed: () {

                      titleController.clear();
                      descController.clear();

                      Navigator.pop(context);
                    },

                    child: Text('Cancel'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}