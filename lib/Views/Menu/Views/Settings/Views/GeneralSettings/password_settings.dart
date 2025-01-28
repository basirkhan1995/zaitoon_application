import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zaitoon_invoice/Bloc/AuthCubit/cubit/auth_cubit.dart';
import 'package:zaitoon_invoice/Bloc/PasswordCubit/password_cubit.dart';
import 'package:zaitoon_invoice/Components/Widgets/outline_button.dart';
import '../../../../../../Components/Widgets/button.dart';
import '../../../../../../Components/Widgets/inputfield_entitled.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PasswordSettings extends StatelessWidget {
  const PasswordSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ZOutlineButton(
                      icon: Icons.lock_clock_rounded,
                      backgroundHover: Theme.of(context).colorScheme.primary,
                      height: 50,
                      width: 250,
                      label: Text(AppLocalizations.of(context)!.changePasswordTitle),
                      onPressed: (){
                        showDialog(context: context, builder: (context){
                          return const ChangePasswordUi();
                        });
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class ChangePasswordUi extends StatefulWidget {
  const ChangePasswordUi({super.key});

  @override
  State<ChangePasswordUi> createState() => _ChangePasswordUiState();
}

class _ChangePasswordUiState extends State<ChangePasswordUi> with SingleTickerProviderStateMixin{
  final currentPassword = TextEditingController();
  final newPassword = TextEditingController();
  final confirmPassword = TextEditingController();

  bool isSecure = true;
  bool isError = false;

  bool isVisible1 = true, isVisible2 = true, isVisible3 = true;

  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((value){
      isError = false;
    });

    isVisible1 = true;
    isVisible2 = true;
    isVisible3 = true;
    super.initState();
  }

  @override
  void dispose() {
    currentPassword.dispose();
    newPassword.dispose();
    confirmPassword.dispose();
    super.dispose();
  }

  int? userId;
  String message = "";

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PasswordCubit, PasswordState>(
      listener: (context, state) {
        if(state is SuccessPasswordChangedState){
          Navigator.pop(context);
        }if(state is PasswordFailureState){
          message = state.error;
        }
      },
      builder: (context, state) {
        return BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if(state is AuthenticatedState){
              userId = state.user.userId;
            }
            return AlertDialog(
              backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
              contentPadding: EdgeInsets.zero,
              insetPadding: EdgeInsets.zero,
              titlePadding: EdgeInsets.zero,
              actionsPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)
              ),
              title: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(AppLocalizations.of(context)!.changePasswordTitle,style: TextStyle(fontSize: 25,color: Theme.of(context).colorScheme.primary)),
                        ),
                        IconButton(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.clear)),

                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(AppLocalizations.of(context)!.passwordSettingHint,style: const TextStyle(fontSize: 12),)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              content: Form(
                key: formKey,
                child: Container(
                    padding: EdgeInsets.zero,
                    width: 350,
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(4)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 15),
                          InputFieldEntitled(
                            controller: currentPassword,
                            title: AppLocalizations.of(context)!.oldPassword,
                            icon: Icons.lock,
                            isRequire: true,
                            securePassword: isVisible1,
                            trailing: IconButton(
                                onPressed: (){
                                  setState(() {
                                    isVisible1 =! isVisible1;
                                  });
                                },
                                icon: Icon(!isVisible1 ? Icons.visibility : Icons.visibility_off_rounded,size: 18,)),
                            validator: (value){
                              if(value.isEmpty){
                                return AppLocalizations.of(context)!.required(AppLocalizations.of(context)!.oldPassword);
                              }
                              return null;
                            },
                          ),
                          InputFieldEntitled(
                            controller: newPassword,
                            title: AppLocalizations.of(context)!.newPassword,
                            icon: Icons.lock,
                            isRequire: true,
                            securePassword: isVisible2,
                            trailing: IconButton(
                                onPressed: (){
                                  setState(() {
                                    isVisible2 =! isVisible2;
                                  });
                                },
                                icon: Icon(!isVisible2 ? Icons.visibility : Icons.visibility_off_rounded,size: 18)),
                            validator: (value){
                              if(value.isEmpty){
                                return AppLocalizations.of(context)!.required(AppLocalizations.of(context)!.newPassword);
                              }
                              return null;
                            },
                          ),
                          InputFieldEntitled(
                            controller: confirmPassword,
                            title: AppLocalizations.of(context)!.confirmPassword,
                            icon: Icons.lock,
                            isRequire: true,
                            securePassword: isVisible3,
                            trailing: IconButton(
                                onPressed: (){
                                  setState(() {
                                    isVisible3 =! isVisible3;
                                  });
                                },
                                icon: Icon(!isVisible3? Icons.visibility : Icons.visibility_off_rounded ,size: 18,)),
                            validator: (value){
                              if(value.isEmpty){
                                return AppLocalizations.of(context)!.required(AppLocalizations.of(context)!.confirmPassword);
                              }else if(newPassword.text != confirmPassword.text){
                                return AppLocalizations.of(context)!.passwordNotMatch;
                              }
                              return null;
                            },
                          ),

                          message.isEmpty? const SizedBox() : Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [Text(message,style: TextStyle(color: Theme.of(context).colorScheme.error),),],
                          ),

                          const SizedBox(height: 8),
                          Button(
                              height: 50,
                              width: MediaQuery.sizeOf(context).width,
                              label: state is PasswordLoadingState? CircularProgressIndicator() : Text(AppLocalizations.of(context)!.update),
                              onPressed: ()async{
                                if(formKey.currentState!.validate()){
                                  context.read<PasswordCubit>().changePasswordEvent(
                                      oldPassword: currentPassword.text,
                                      newPassword: newPassword.text,
                                      userId: userId!,
                                      message: AppLocalizations.of(context)!.passwordErrorMessage
                                  );
                                }
                              }),

                          const SizedBox(height: 14),
                        ],
                      ),
                    )
                ),
              ),
            );
          },
        );
      },
    );
  }

}





