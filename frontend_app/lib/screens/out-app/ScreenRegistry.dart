
import 'package:flutter/material.dart';
import 'package:frontend_app/data/providers/UserProvider.dart';
import 'package:frontend_app/data/providers/UserTypeProvider.dart';
import 'package:frontend_app/text_content/TextContent.dart';
import 'package:frontend_app/data/models/User.dart';
import 'package:frontend_app/data/models/UserType.dart';
import 'package:frontend_app/data/models/country.dart';
import 'package:frontend_app/data/providers/CountryProvider.dart';

import 'package:frontend_app/widgets/elements/DatePicker.dart';
import 'package:frontend_app/widgets/Dialogs.dart';
import 'package:frontend_app/widgets/elements/buttons_elements.dart';
import 'package:frontend_app/widgets/Checkbox.dart';
import 'package:frontend_app/widgets/DropdownButtonFormField.dart';
import 'package:frontend_app/widgets/TextFormField.dart';
import 'package:provider/provider.dart';

class ScreenRegistry extends StatefulWidget {
  const ScreenRegistry({super.key});

  @override
  State<ScreenRegistry> createState() => _ScreenRegistryState();
}

class _ScreenRegistryState extends State<ScreenRegistry> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _formUserName = '';
  String _formPassHash = '';
  String _formConfirmPass = '';
  String _formEmail = '';
  String _formProfileImage = '';
  String _formPhoneNumber = '';

  DateTime? _selectedDate;
  String _selectedCountry = "España";
  String _selectedTypeUser = "Particular";
  late DateTime _formBirthdayDate;
  bool _aceptaTerminos = false;
  bool _aceptaNotificaciones = false;
  

  Future<void> _aceptar() async {
    //Navigator.pop(context);
    if (_formKey.currentState!.validate()) {
      // Process data.
      _formKey.currentState!.save();
    }
    _formBirthdayDate = DateTime(_selectedDate as int);
    
    
    // Crear un objeto User
    User user = User(
      userId: 0,
      userName: _formUserName,
      passHash: _formPassHash,
      email: _formEmail,
      profileImage: _formProfileImage,
      emailNotifications: true,
      birthdayDate: _formBirthdayDate.millisecondsSinceEpoch,
      fkCountry: Country(countryId: 0, countryName: _selectedCountry),
      fkUserType: UserType(userTypeId: 3, userTypeName: _selectedTypeUser),
    );

    final usuarioProvider =
        Provider.of<UserProvider>(context, listen: false);
    await usuarioProvider.registryUser(user);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Usuario guardado correctamente')),
    );
    Navigator.pop(context);
  }

  void cancelar() => Navigator.pop(context);

  @override
  Widget build(BuildContext context) {
    var group;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF0B0B22),
          title: const Text(" FORMULARIO DE REGISTRO"),
          titleTextStyle: TextStyle(color: Colors.white),
          centerTitle: true,
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.center,
              colors: [
                Color(0xFF0B0B22), 
                Color(0xFF1B1B3A), 
                Color(0xFF2A144B), 
              ],
            ),
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 500, // Ancho máximo en píxeles
              ),
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromARGB(255, 52, 43, 83), Color.fromARGB(255, 18, 18, 41),  Color(0xFF0B0B22)                     
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(192, 0, 0, 0),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.white,
                    width: 1,
                  ),
                ),
                child:  SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        const SizedBox(
                          height: 20,
                          width: 20,
                        ),

                        StandardTextFormField(
                          labelText: 'Email *',
                          hintText: 'Introduce tu email...',
                          obscureText: false,
                          onSaved: (newValue) => _formEmail = newValue!,
                          onlyNumbers: false,
                          validator: (value) =>
                              value == null || value.isEmpty ? 'Campo obligatorio' : null,
                        ),
                        
                        const SizedBox(
                          height: 20,
                          width: 20,
                        ),

                        StandardTextFormField(
                          labelText: 'Nombre de Usuario *',
                          hintText: 'Introduce tu nombre de usuario...',
                          obscureText: false,
                          onSaved: (newValue) => _formUserName = newValue!,
                          onlyNumbers: false,
                          validator: (value) =>
                              value == null || value.isEmpty ? 'Campo obligatorio' : null,
                        ),
                        
                        const SizedBox(
                          height: 20,
                          width: 20,
                        ),

                        StandardTextFormField(
                          labelText: 'Contraseña *',
                          hintText: 'Introduce tu contraseña...',
                          obscureText: true,
                          onSaved: (pass) => _formPassHash = pass!,
                          onlyNumbers: false,
                          validator: (value) =>
                              value == null || value.isEmpty ? 'Campo obligatorio' : null,
                        ),
                      
                        const SizedBox(
                          height: 20,
                          width: 20,
                        ),
                        
                        StandardTextFormField(
                          labelText: 'Confirmar Contraseña *',
                          hintText: 'Repite tu contraseña...',
                          obscureText: true,
                          onSaved: (pass) => _formConfirmPass = pass!,
                          onlyNumbers: false,
                          validator: (value) =>
                              value == null || value.isEmpty ? 'Campo obligatorio' : null,
                        ),
                      
                        const SizedBox(
                          height: 20,
                          width: 20,
                        ),                      
                        
                        DateSelectorDropdown(
                          onDateChanged: (date) {
                            _selectedDate = date;
                          },
                          initialDate: DateTime(2000, 1, 1), 
                        ),

                        const SizedBox(
                          height: 20,
                          width: 20,
                        ),

                        StandardTextFormField(
                          labelText: 'Número Teléfono',
                          hintText: 'Introduce un número de telefono...',
                          obscureText: false,
                          onSaved: (value) => _formPhoneNumber = value!,
                          onlyNumbers: true,
                        ),
                                                                       
                        const SizedBox(
                          height: 20,
                          width: 20,
                        ),

                        StandardDropdownButtonFormField(
                          labelText: "País",
                          value: _selectedCountry,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedCountry = newValue as String;
                            });
                          },
                          items: Provider.of<CountryProvider>(context, listen: true)
                              .countries
                              .map<DropdownMenuItem<String>>((Country country) {
                                return DropdownMenuItem<String>(
                                  value: country.countryName,
                                  child: Text(country.countryName),
                                );
                              })
                              .toList(),
                        ),

                        const SizedBox(
                          height: 20,
                          width: 20,
                        ),

                        StandardDropdownButtonFormField(
                          labelText: "Tipo de Usuario",
                          value: _selectedTypeUser,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedTypeUser = newValue as String;
                            });
                          },
                          items: Provider.of<UserTypeProvider>(context, listen: true)
                              .userTypes
                              .map<DropdownMenuItem<String>>((UserType userType) {
                                return DropdownMenuItem<String>(
                                  value: userType.userTypeName,
                                  child: Text(userType.userTypeName),
                                );
                              })
                              .toList(),
                        ),

                        const SizedBox(
                          height: 20,
                          width: 20,
                        ),

                        checkBoxWithLink(
                          _aceptaTerminos, 
                          (value) {
                            setState(() {
                              _aceptaTerminos = value!;
                            });
                          }, 
                          "Acepto los ", 
                          "términos y condiciones",
                          () {
                            Dialogs.mostrarTerminosDialog(context);
                          },
                          context),
                        

                        checkBoxWithLink(
                          _aceptaNotificaciones, 
                          (value) {
                            setState(() {
                              _aceptaNotificaciones = value!;
                            });
                          }, 
                          "Acepto recibir notificaciones por email", 
                          "",
                          () {
                            Dialogs.mostrarTerminosDialog(context);
                          },
                          context),

                        const SizedBox(
                          height: 20,
                          width: 20,
                        ),

                        standardButton("Registrarse", () {_aceptar();}),
                        
                        const SizedBox(
                          height: 20,
                          width: 20,
                        ),
                        
                        standardButton(TextContent.cancelAction, () {cancelar();}),
                      ],
                    ),
                  ),
                ),
              )         
            )
          ),
        ) 
    );
  }
}
