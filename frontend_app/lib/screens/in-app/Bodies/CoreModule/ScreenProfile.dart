import 'package:flutter/material.dart';
import 'package:frontend_app/data/models/User.dart';
import 'package:frontend_app/data/models/UserType.dart';
import 'package:frontend_app/data/models/country.dart';
import 'package:frontend_app/data/providers/CountryProvider.dart';
import 'package:frontend_app/data/providers/UserProvider.dart';
import 'package:frontend_app/data/providers/UserTypeProvider.dart';
import 'package:frontend_app/screens/in-app/ScreenMaster.dart';
import 'package:frontend_app/text_content/TextContent.dart';
import 'package:frontend_app/widgets/Checkbox.dart';
import 'package:frontend_app/widgets/Dialogs.dart';
import 'package:frontend_app/widgets/DropdownButtonFormField.dart';
import 'package:frontend_app/widgets/Navigation.dart';
import 'package:frontend_app/widgets/TextFormField.dart';
import 'package:frontend_app/widgets/elements/DatePicker.dart';
import 'package:frontend_app/widgets/elements/buttons_elements.dart';
import 'package:provider/provider.dart';

class ScreenProfile extends StatefulWidget {
  const ScreenProfile({super.key, required this.user});

  final User user;




  @override
  State<ScreenProfile> createState() => _ScreenProfileState();
}

class _ScreenProfileState extends State<ScreenProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controladores
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  // Otros campos
  String _formUserName = '';
  String _formPassHash = '';
  String _formEmail = '';
  String _formPhoneNumber = '';
  late DateTime _formBirthdayDate;
  DateTime? _selectedDate;
  String _selectedCountry = "";
  String _selectedTypeUser = "";
  bool _aceptaNotificaciones = false;

  @override
  void initState() {
    super.initState();

    // Asignar valores iniciales desde widget.user
    _emailController.text = widget.user.email;
    _userNameController.text = widget.user.userName;
    _passwordController.text = Provider.of<UserProvider>(context, listen: false).decodeFromBase64(widget.user.passHash);
    _phoneNumberController.text = widget.user.phoneNumber.toString();
    _selectedDate = widget.user.creationDate; 
    _selectedCountry = widget.user.fkCountry.countryName;
    _selectedTypeUser = widget.user.fkUserType.userTypeName;
    _aceptaNotificaciones = widget.user.emailNotifications;
  }

  void _updateProfile() {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    _formBirthdayDate = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
    );

    final user = User(
      userId: widget.user.userId,
      userName: _formUserName,
      passHash: _formPassHash,
      email: _formEmail,
      profileImage: widget.user.profileImage,
      emailNotifications: _aceptaNotificaciones,
      phoneNumber: int.tryParse(_formPhoneNumber) ?? 0,
      creationDate: _formBirthdayDate,
      fkCountry: Country(countryId: 0, countryName: _selectedCountry),
      fkUserType: UserType(userTypeId: 0, userTypeName: _selectedTypeUser),
    );

    Provider.of<UserProvider>(context, listen: false)
        .accountEdit(widget.user.userId, user);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Usuario actualizado correctamente')),
    );
    
    Navigation.GoToScreen(context, ScreenMaster(user: user));
  }

  void cancelar() => Navigator.pop(context);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 52, 43, 83),
                Color.fromARGB(255, 18, 18, 41),
                Color(0xFF0B0B22)
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(192, 0, 0, 0),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
            border: Border.all(color: Colors.white, width: 1),
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  StandardTextFormField(
                    controller: _emailController,
                    labelText: 'Email',
                    hintText: 'Introduce tu email...',
                    obscureText: false,
                    onlyNumbers: false,
                    onSaved: (value) => _formEmail = value!,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo obligatorio';
                      }
                      final emailRegExp =
                          RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (!emailRegExp.hasMatch(value)) {
                        return 'Introduce un email válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  StandardTextFormField(
                    controller: _userNameController,
                    labelText: 'Nombre de Usuario',
                    hintText: 'Introduce tu nombre de usuario...',
                    obscureText: false,
                    onlyNumbers: false,
                    onSaved: (value) => _formUserName = value!,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Campo obligatorio'
                        : null,
                  ),
                  const SizedBox(height: 20),
                  StandardTextFormField(
                    controller: _passwordController,
                    labelText: 'Contraseña',
                    hintText: 'Introduce tu contraseña...',
                    obscureText: true,
                    onlyNumbers: false,
                    onSaved: (value) => _formPassHash = value!,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo obligatorio';
                      }
                      if (value.length < 6) {
                        return 'Debe tener al menos 6 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  DateSelectorDropdown(
                    onDateChanged: (date) {
                      _selectedDate = date;
                    },
                    initialDate: _selectedDate,
                  ),
                  const SizedBox(height: 20),
                  StandardTextFormField(
                    controller: _phoneNumberController,
                    labelText: 'Número Teléfono',
                    hintText: 'Introduce un número de teléfono...',
                    obscureText: false,
                    onlyNumbers: true,
                    onSaved: (value) => _formPhoneNumber = value!,
                  ),
                  const SizedBox(height: 20),
                  StandardDropdownButtonFormField(
                    labelText: "País",
                    value: _selectedCountry,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCountry = newValue!;
                      });
                    },
                    items: Provider.of<CountryProvider>(context)
                        .countries
                        .map((country) => DropdownMenuItem<String>(
                              value: country.countryName,
                              child: Text(country.countryName),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 20),
                  StandardDropdownButtonFormField(
                    labelText: "Tipo de Usuario",
                    value: _selectedTypeUser,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedTypeUser = newValue!;
                      });
                    },
                    items: Provider.of<UserTypeProvider>(context)
                        .userTypes
                        .map((type) => DropdownMenuItem<String>(
                              value: type.userTypeName,
                              child: Text(type.userTypeName),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 20),
                  checkBoxWithLink(
                    _aceptaNotificaciones,
                    (value) => setState(() => _aceptaNotificaciones = value!),
                    "Acepto recibir notificaciones por email",
                    "",
                    () => Dialogs.showTermsDialog(context),
                    context,
                  ),
                  const SizedBox(height: 20),
                  standardButton("Actualizar", _updateProfile),
                  const SizedBox(height: 20),
                  deleteButton(context, widget.user.userId),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
