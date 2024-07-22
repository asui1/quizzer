import 'dart:convert';
import 'package:crypto/crypto.dart';

String generateUniqueIdFromStrings(String string1, String string2) {
  // Hash the first string
  var hash1 = sha256.convert(utf8.encode(string1));

  // Hash the second string
  var hash2 = sha256.convert(utf8.encode(string2));

  // Combine the two hashes by XORing their bytes
  List<int> combinedHash = List<int>.generate(hash1.bytes.length, (index) {
    return hash1.bytes[index] ^ hash2.bytes[index];
  });

  // Optionally, hash the combined result for uniformity
  var finalHash = sha256.convert(combinedHash);

  // Convert the hash to a string (e.g., in hexadecimal format)
  return finalHash.toString();
}

String generateUniqueId(String uuid, String email, String quizTitle) {
  // Concatenate UUID, email, and quizTitle
  String concatenated = "$uuid-$email-$quizTitle";

  // (Optional) Hash the concatenated string for a uniform, unique ID
  // This step is optional and can be skipped if you prefer the raw concatenated string
  var bytes = utf8.encode(concatenated); // data being hashed
  String hashed = sha256.convert(bytes).toString();

  return hashed; // Or return concatenated if you skip hashing
}