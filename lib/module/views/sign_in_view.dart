import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:video_api/module/controllers/auth_controller.dart';

final isOscureTextProvider = StateProvider<bool>((ref) {
  return true;
});

class SignInView extends ConsumerWidget {
  SignInView({super.key});

  final formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOscureText = ref.watch(isOscureTextProvider);
    final screenSize = MediaQuery.of(context).size;
    var shortestSide = screenSize.shortestSide;
    final bool useMobileLayout = shortestSide < 600;

    void signIn() async {
      final isValidated = formKey.currentState?.saveAndValidate() ?? false;
      if (!isValidated) {
        return;
      }

      final email = formKey.currentState?.value['email'];
      final password = formKey.currentState?.value['password'];
      ref.read(authControllerProvider.notifier).signIn(email: email, password: password);
    }

    ref.listen(authControllerProvider, (_, state) {
      if (state is Unauthenticated) {
        if (state.message == null) {
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message!)));
      }
    });

    return Scaffold(
      body: Center(
        child: OutlinedButton(
          onPressed: null,
          child: SizedBox(
            height: screenSize.height / 1.5,
            width: useMobileLayout ? screenSize.width / 1.2 : screenSize.width / 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: FormBuilder(
                  key: formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        "assets/logo.png",
                        height: 100,
                      ),
                      const SizedBox(height: 10),
                      FormBuilderTextField(
                        name: "email",
                        initialValue: "admin@admin.com",
                        decoration: const InputDecoration(
                          label: Text("Correo electrónico"),
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.email(),
                        ]),
                      ),
                      const SizedBox(height: 10),
                      FormBuilderTextField(
                        name: "password",
                        initialValue: "vCOMPANY2012##admin",
                        decoration: InputDecoration(
                          label: const Text("Contaseña"),
                          suffixIcon: IconButton(
                            onPressed: () {
                              ref.read(isOscureTextProvider.notifier).update((state) => !isOscureText);
                            },
                            icon: !isOscureText ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
                          ),
                        ),
                        obscureText: isOscureText,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.minLength(8),
                        ]),
                      ),
                      const SizedBox(height: 40),
                      Consumer(builder: (context, ref, _) {
                        final authState = ref.watch(authControllerProvider);

                        if (authState is AuthLoading) {
                          return SizedBox(
                            height: 40,
                            width: screenSize.width,
                            child: const ElevatedButton(
                              onPressed: null,
                              child: LinearProgressIndicator(),
                            ),
                          );
                        }

                        return SizedBox(
                          height: 40,
                          width: screenSize.width,
                          child: ElevatedButton(
                            onPressed: signIn,
                            child: const Text("Iniciar Sesión"),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
