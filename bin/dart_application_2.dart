import 'dart:io';
import 'dart:math';

void main() {
  final int size = 5; // Размер игрового поля
  List<List<String>> board = List.generate(size, (_) => List.filled(size, '~'));
  List<List<bool>> ships = List.generate(size, (_) => List.filled(size, false));

  int shipsToPlace = 3; // Количество кораблей
  placeShips(ships, shipsToPlace);

  int attempts = 0;
  int hits = 0;

  print("Добро пожаловать в Морской бой!");
  while (hits < shipsToPlace) {
    printBoard(board);
    print("Введите координаты выстрела (формат: x y):");
    List<int> shot = getShot(size);
    attempts++;

    int x = shot[0], y = shot[1];
    if (ships[x][y]) {
      print("Попадание!");
      board[x][y] = 'X';
      ships[x][y] = false;
      hits++;
    } else {
      print("Мимо!");
      board[x][y] = 'O';
    }
  }

  print("Поздравляем! Вы подбили все корабли за $attempts попыток.");
}

void placeShips(List<List<bool>> ships, int shipsToPlace) {
  Random rand = Random();
  int size = ships.length;

  while (shipsToPlace > 0) {
    int x = rand.nextInt(size);
    int y = rand.nextInt(size);

    if (!ships[x][y]) {
      ships[x][y] = true;
      shipsToPlace--;
    }
  }
}

void printBoard(List<List<String>> board) {
  print("  ${List.generate(board.length, (i) => i).join(' ')}");
  for (int i = 0; i < board.length; i++) {
    print("$i ${board[i].join(' ')}");
  }
}

List<int> getShot(int size) {
  while (true) {
    try {
      List<String> input = stdin.readLineSync()!.split(' ');
      if (input.length != 2) throw FormatException();

      int x = int.parse(input[0]);
      int y = int.parse(input[1]);

      if (x >= 0 && x < size && y >= 0 && y < size) {
        return [x, y];
      } else {
        print("Координаты вне поля. Попробуйте снова.");
      }
    } catch (e) {
      print("Некорректный ввод. Введите два числа, разделенных пробелом.");
    }
  }
}
