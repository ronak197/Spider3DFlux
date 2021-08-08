// List myList = ['A', 'B', 'C', 'D',];
List myList = ['P1', 'P2', 'P3', 'P4'];

// Replace places of values in the list (A,B,C -> B,A,C), At Least 1 value should be in list!
void replaceInList(List list, a, b) {
  // Define values places
  var list_len = list.length;
  var a_index = list.indexOf(a);
  var b_index = list.indexOf(b);

  // Add (1) Value if not in list
  if (a_index == -1) list.add(a); // AKA null
  if (b_index == -1) list.add(b);

  // Redefine values places
  a_index = list.indexOf(a);
  b_index = list.indexOf(b);

  // Switch between their places
  list.insert(a_index, b); // means .addAt
  list.removeAt(a_index + 1);

  list.insert(b_index, a); // means .addAt
  list.removeAt(b_index + 1);

  // Remove rest unnecessary value if left
  if (list_len != list.length) list.removeAt(list.length - 1);
}

void main() {
  // myList.insert(1, 'B');
  // myList.insert(2, 'C');
  // myList.insert(0, 'A');
  // myList.insert(3, 'D');

  replaceInList(myList, 'B', 'P2');
  print(myList);
}

// void main() {
//   // var grade = "A";
//   for (var grade in myList) {
//     switch (grade) {
//       case "A":
//         {
//           print("Excellent");
//         }
//         break;
//
//       case "B":
//         {
//           print("Good");
//         }
//         break;
//
//       default:
//         // {
//         //   print("Invalid choice");
//         // }
//         break;
//     }
//   }
// }
