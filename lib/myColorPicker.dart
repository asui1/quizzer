import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quizzer/Class/ImageColor.dart';
import 'package:quizzer/Class/quizLayout.dart';

class ColorPickerField extends StatefulWidget {
  final QuizLayout quizLayout;
  final int index;

  ColorPickerField({required this.quizLayout, required this.index});
  @override
  _ColorPickerFieldState createState() => _ColorPickerFieldState();
}

class _ColorPickerFieldState extends State<ColorPickerField> {
  Color pickerColor = Colors.white;
  XFile? imageFile;
  TextEditingController hexController = TextEditingController();
  bool isHexCodeValid = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.index > 2) {
      pickerColor = widget.quizLayout.getColor(widget.index);
    } else {
      pickerColor = widget.quizLayout.getImage(widget.index).isColor()
          ? widget.quizLayout.getImage(widget.index).getColor()
          : Colors.white;
    }
    imageFile = widget.quizLayout.getImage(widget.index).imagePath == null
        ? null
        : XFile(widget.quizLayout.getImage(widget.index).getImagePath());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width / 3,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                children: [
                  ColorPicker(
                    pickerColor: pickerColor,
                    onColorChanged: (newColor) {
                      setState(() {
                        pickerColor = newColor;
                        hexController.text = newColor.value
                            .toRadixString(16)
                            .substring(2); // Ignore alpha
                      });
                    },
                    portraitOnly: true,
                    showLabel: false,
                    pickerAreaHeightPercent: 0.8,
                    enableAlpha: false,
                  ),
                  TextField(
                    controller: hexController,
                    maxLength: 6,
                    decoration: InputDecoration(
                      labelText: 'Hex code',
                      errorText: isHexCodeValid ? null : 'Invalid hex code',
                    ),
                    onChanged: (value) {
                      try {
                        setState(() {
                          pickerColor = new Color(int.parse('ff' + value,
                              radix: 16)); // Add 'ff' for full opacity
                          isHexCodeValid = true;
                        });
                      } catch (e) {
                        // Handle invalid hex code
                        setState(() {
                          isHexCodeValid = false;
                        });
                      }
                    },
                  ),
                ],
              ),
              widget.index < 3
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Current Path: ${imageFile == null ? 'No image selected' : '...${imageFile!.path.split('/').last}'}',
                            style: TextStyle(fontSize: 16),
                            maxLines: 1,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: SizedBox.shrink(), // 정렬을 위한 자리 표시자
                              ),
                              ElevatedButton(
                                child: Text('Pick Image'),
                                onPressed: () async {
                                  final ImagePicker _picker = ImagePicker();
                                  final XFile? tempImageFile = await _picker
                                      .pickImage(source: ImageSource.gallery);
                                  if (tempImageFile != null) {
                                    // 이미지 파일 처리
                                    setState(() {
                                      imageFile = tempImageFile;
                                    });
                                  }
                                },
                              ),
                              Expanded(
                                child: TextButton(
                                  child: Text('X'),
                                  onPressed: () {
                                    setState(() {
                                      imageFile = null;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('확인'),
          onPressed: () {
            if(widget.index > 2){
              widget.quizLayout.setColor(widget.index, pickerColor);

            }
            else{
            widget.quizLayout.setImage(widget.index,
                ImageColor(imagePath: imageFile?.path, color: pickerColor));
            }
            Navigator.of(context).pop(pickerColor);
          },
        ),
      ],
    );
  }
}
