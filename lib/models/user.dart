// class UserModel {
//   final String id;
//   final String username;
//   final String email;
//   String? pairedId;
//
//   UserModel({required this.id, required this.username, required this.email, this.pairedId});
//
//   factory UserModel.fromJson(Map<String, dynamic> json) {
//     return UserModel(
//       id: json['uid'],
//       username: json['username'],
//       email: json['email'],
//       pairedId: json['pair']
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'uid': id,
//       'username': username,
//       'email': email,
//       'pairedId': pairedId,
//     };
//   }
// }
