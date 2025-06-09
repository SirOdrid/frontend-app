import 'package:flutter/material.dart';
import 'package:frontend_app/Styles/buttons_styles.dart';
import 'package:intl/intl.dart';

import 'package:frontend_app/data/models/User.dart';
import 'package:frontend_app/data/models/UserAssociate.dart';
import 'package:frontend_app/data/providers/UserAssociateProvider.dart';
import 'package:frontend_app/widgets/elements/buttons_elements.dart';
import 'package:provider/provider.dart';

Widget baseUserCard(User user) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      CircleAvatar(
        radius: 40,
        backgroundColor: Colors.transparent,
        backgroundImage: AssetImage(
          user.fkUserType.userTypeName.toLowerCase() == 'particular'
              ? 'images/singleuser.png'
              : 'images/asociationuser.png',
        ),
      ),
      const SizedBox(width: 16),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.userName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
            const SizedBox(height: 8),
            Text(
              '${user.fkUserType.userTypeName} - ${user.fkCountry.countryName}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
          ],
        ),
      ),
    ],
  );
}

Widget baseAssociateUserCard(UserAssociate association, bool esParticular) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      CircleAvatar(
        radius: 40,
        backgroundColor: Colors.transparent,
        backgroundImage: AssetImage(
          esParticular
          ? association.fkHostUser.fkUserType.userTypeName.toLowerCase() ==
                  'particular'
              ? 'images/singleuser.png'
              : 'images/asociationuser.png'
          : association.fkAssociatedUser.fkUserType.userTypeName.toLowerCase() ==
                  'particular'
              ? 'images/singleuser.png'
              : 'images/asociationuser.png',
        ),
      ),

      const SizedBox(width: 16),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
               esParticular
                  ? association.fkHostUser.userName
                  : association.fkAssociatedUser.userName,              
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
            const SizedBox(height: 8),
            Text(
              esParticular
                  ? '${association.fkHostUser.fkUserType.userTypeName} - ${association.fkHostUser.fkCountry.countryName}'
                  : '${association.fkAssociatedUser.fkUserType.userTypeName} - ${association.fkAssociatedUser.fkCountry.countryName}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white70
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                ),
                children: [
                  const TextSpan(
                    text: 'Fecha de Asociación: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: DateFormat('dd/MM/yyyy')
                        .format(association.associationDate),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget userWithAsociationCard(
  UserAssociate association, User activeUser, BuildContext context, bool esParticular) {
  return Card(
    color: const Color.fromARGB(255, 60, 43, 148),
    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          baseAssociateUserCard(association, esParticular),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              standardButton(
                "ELIMINAR",
                () {
                  Provider.of<UserAssociateProvider>(context, listen: false)
                      .deleteAssociation(
                          association.userAssociateId, activeUser.userId);
                },
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
Widget userWithoutAsociationCard(
    User user, User activeUser, BuildContext context) {
  return Card(
    color: const Color.fromARGB(255, 60, 43, 148),
    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: baseUserCard(user)),
              IconButton(
                iconSize: 40,
                icon: const Icon(Icons.info_outline, color: Colors.green),
                tooltip: 'Información',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: Colors.grey[850],
                      title: const Text('Información sobre Asociación', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),),
                      content: const Text('Al asociarse a un usuario, le otorga el derecho y da el consentimiento para poder ser incluido en sesiones de juego. Además, si el usuario es un usuario corporativo, da su consentimiento para que la información relacionada con su colección de juegos y su actividad sea utiliza con fines de analisis y estadisticos desde el anonimato. Bajo ninguna circunstancia se compartirá con el usuario al que se asocia información directa de usted o información que pudiera identificarle.', style: TextStyle(color: Colors.white),),
                      actions: [
                        TextButton(
                          style: TextButton.styleFrom(backgroundColor: Colors.green),
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cerrar', style: TextStyle(color: Colors.white),),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                decoration: DecorationBoxButton(8),
                child: ElevatedButton.icon(
                  onPressed: () async {
                    Provider.of<UserAssociateProvider>(context, listen: false)
                        .addAssociation(user, activeUser);
                  },
                  icon: const Icon(Icons.assignment, color: Colors.white, size: 16),
                  label: const Text("ASOCIARSE"),
                  style: styleButton(),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

