import 'package:fluent_ui/fluent_ui.dart';
import 'package:point_of_sale/dev/dev_models/developer.dart';
import 'package:point_of_sale/widget/loading_widget.dart';

class DevProfileScreen extends StatefulWidget {
  const DevProfileScreen({super.key});

  @override
  State<DevProfileScreen> createState() => _DevProfileScreenState();
}

class _DevProfileScreenState extends State<DevProfileScreen> {
  String imageUrl = "https://picsum.photos/id/238/200/300";
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _subTitleController = TextEditingController();
  bool isLoading = false;
  bool isLoadingData = false;

  void update()async{
    Developer dev = Developer(mobile: _mobileController.text,name: _nameController.text, subTitle: _subTitleController.text, image: _imageUrlController.text, email: _emailController.text);
    setState(() {
      isLoading = true;
    });
    await dev.addDeveloper();
    setState(() {
      isLoading = false;
    });

  }

  void loadDeveloper()async{
    setState(() {
      isLoadingData = true;
    });
    Developer dev = await Developer.getDev();
    setState(() {
      _nameController.text = dev.name;
      _subTitleController.text = dev.subTitle;
      _emailController.text = dev.email;
      _imageUrlController.text = dev.image;
      _mobileController.text = dev.mobile;
      imageUrl = dev.image;
      isLoadingData = false;
    });
  }

  @override
  void initState() {
    loadDeveloper();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {



    return isLoadingData ? const Center(child: LoadingWidget(),) : ScaffoldPage.scrollable(

      children: [
        Center(child: Text("Developer Profile",style: FluentTheme.of(context).typography.title!.copyWith(fontWeight: FontWeight.bold),)),
        const SizedBox(height: 20,),
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(200),
            child: Image.network(imageUrl,width: 100,height: 100,fit: BoxFit.fill),
          )
        ),
        const SizedBox(height: 20,),
        Center(
          child: SizedBox(
            width: 250,
            child: InfoLabel(label: "Image URL",child: TextBox(
              placeholder: "Image URL",
              controller: _imageUrlController,
              onSubmitted: (value) {
                print(imageUrl);
                imageUrl = value;
                print(imageUrl);

                _imageUrlController.text = value;
                setState(() {

                });
              },
            )),
          ),
        ),
        Center(
          child: SizedBox(
            width: 250,
            child: InfoLabel(label: "Name",child: TextBox(controller: _nameController,)),
          ),
        ),
        Center(
          child: SizedBox(
            width: 250,
            child: InfoLabel(label: "Email",child: TextBox(controller: _emailController,)),
          ),
        ),
        Center(
          child: SizedBox(
            width: 250,
            child: InfoLabel(label: "Mobile",child: TextBox(controller: _mobileController,)),
          ),
        ),
        Center(
          child: SizedBox(
            width: 250,
            child: InfoLabel(label: "SubTitle",child: TextBox(controller: _subTitleController,)),
          ),
        ),
        SizedBox(height: 10,),
        Center(
          child: FilledButton(
            onPressed:isLoading ? (){}:update,
            child: Text(isLoading ? "Updating..." : "Update"),
          ),
        )
      ],
    );
  }
}
