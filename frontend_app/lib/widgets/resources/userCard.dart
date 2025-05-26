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
      // Imagen del juego con fallback
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
                fontSize: 18,
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
                fontSize: 16,
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
                fontSize: 18,
                fontWeight: FontWeight.bold,
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
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 16,
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
    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          baseUserCard(user),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                  decoration: DecorationBoxButton(8),
                  child: ElevatedButton.icon(
                      onPressed: () async {
                        Provider.of<UserAssociateProvider>(context,
                                listen: false)
                            .addAssociation(user, activeUser);
                      },
                      icon:
                          Icon(Icons.assignment, color: Colors.white, size: 16),
                      label: Text("ASOCIARSE"),
                      style: styleButton()))
            ],
          ),
        ],
      ),
    ),
  );
}
