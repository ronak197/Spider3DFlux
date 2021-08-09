List myList = ['A', 'B', 'C', 'D'];
// List myList = ['P1', 'P2', 'P3', 'P4'];
// List myList = [Tag {"id":4781,"name":"+Pla","slug":"pla","description":"","count":10}, Tag {"id":4920,"name":"2 צבעים","slug":"2-%d7%a6%d7%91%d7%a2%d7%99%d7%9d","description":"","count":2}, Tag {"id":2563,"name":"24V","slug":"24v","description":"","count":1}, Tag {"id":4857,"name":"3d","slug":"3d","description":"","count":2}, Tag {"id":3240,"name":"3D PRINTER","slug":"3d-printer","description":"","count":3}, Tag {"id":4876,"name":"ABS","slug":"abs","description":"","count":1}, Tag {"id":4823,"name":"Artillery","slug":"artillery","description":"","count":3}, Tag {"id":2566,"name":"cr-10","slug":"cr-10","description":"","count":1}, Tag {"id":2567,"name":"cr-10s","slug":"cr-10s","description":"","count":1}, Tag {"id":2568,"name":"cr-10s pro","slug":"cr-10s-pro","description":"","count":1}, Tag {"id":4849,"name":"Creality","slug":"creality","description":"","count":7}, Tag {"id":4892,"name":"Cura","slug":"cura","description":"","count":1}, Tag {"id":3239,"name":"DIY","slug":"diy","description":"","count":3}, T;

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
  // myList.insert('A', 'B');
  // myList.insert(2, 'C');
  // myList.insert(0, 'A');
  // myList.insert(3, 'D');

  replaceInList(myList, 'B', 'A');
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
