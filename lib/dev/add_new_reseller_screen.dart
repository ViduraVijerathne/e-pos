import 'package:fluent_ui/fluent_ui.dart';
import 'package:point_of_sale/dev/dev_models/Reseller.dart';

class AddNewResellerScreen extends StatefulWidget {
  const AddNewResellerScreen({super.key});

  @override
  State<AddNewResellerScreen> createState() => _AddNewResellerScreenState();
}

class _AddNewResellerScreenState extends State<AddNewResellerScreen> {
  String imageUrl = "https://picsum.photos/id/238/200/300";
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;
  bool isLoadingData = false;
  void add()async{
    setState(() {
      isLoading = true;
    });
    Reseller reseller = Reseller(email: _emailController.text, password: _passwordController.text, name: _nameController.text, mobile: _mobileController.text, isActivated: true, image: _imageUrlController.text);
    await reseller.addReseller();

    // Developer dev = Developer(mobile: _mobileController.text,name: _nameController.text, subTitle: _subTitleController.text, image: _imageUrlController.text, email: _emailController.text);

    // await dev.addDeveloper();
    setState(() {
      isLoading = false;
    });

  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.scrollable(

      children: [
        Center(child: Text("Add New Reseller",style: FluentTheme.of(context).typography.title!.copyWith(fontWeight: FontWeight.bold),)),
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
            child: InfoLabel(label: "Password",child: TextBox(controller: _passwordController,)),
          ),
        ),
        SizedBox(height: 10,),
        Center(
          child: FilledButton(
            onPressed:isLoading ? (){}:add,
            child: Text(isLoading ? "Adding..." : "Add"),
          ),
        )
      ],
    );
  }
}
