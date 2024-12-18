import 'dart:io';
import 'dart:math';

void main() {
  final int size = 5; // Размер игрового поля
  List<List<String>> board = List.generate(size, (_) => List.filled(size, '~'));
  List<List<bool>> ships = List.generate(size, (_) => List.filled(size, false));

  int shipsToPlace = 3; // Количество кораблей
  placeShips(ships, shipsToPlace);

  int attemptsPlayer1 = 0, attemptsPlayer2 = 0;
  int hitsPlayer1 = 0, hitsPlayer2 = 0;
  int missesPlayer1 = 0, missesPlayer2 = 0;

  String currentPlayer = 'Игрок 1'; // Игроки по очереди

  print("Добро пожаловать в Морской бой!");
  while (hitsPlayer1 + hitsPlayer2 < shipsToPlace) {
    printBoard(board);
    print("$currentPlayer, введите координаты выстрела (формат: x y):");
    List<int> shot = getShot(size);

    if (currentPlayer == 'Игрок 1') {
      attemptsPlayer1++;
    } else {
      attemptsPlayer2++;
    }

    int x = shot[0], y = shot[1];
    if (ships[x][y]) {
      print("Попадание!");
      board[x][y] = 'X';
      ships[x][y] = false;
      if (currentPlayer == 'Игрок 1') {
        hitsPlayer1++;
      } else {
        hitsPlayer2++;
      }
    } else {
      print("Мимо!");
      board[x][y] = 'O';
      if (currentPlayer == 'Игрок 1') {
        missesPlayer1++;
      } else {
        missesPlayer2++;
      }
    }

    // Переключаем игрока
    currentPlayer = (currentPlayer == 'Игрок 1') ? 'Игрок 2' : 'Игрок 1';
  }

  print("Игра окончена!");

  // Сбор статистики
  String stats = '''
    Статистика игры:
    Игрок 1:
    - Попадания: $hitsPlayer1
    - Промахи: $missesPlayer1
    - Всего попыток: $attemptsPlayer1
    - Оставшиеся корабли на поле: ${shipsToPlace - hitsPlayer1}
    
    Игрок 2:
    - Попадания: $hitsPlayer2
    - Промахи: $missesPlayer2
    - Всего попыток: $attemptsPlayer2
    - Оставшиеся корабли на поле: ${shipsToPlace - hitsPlayer2}
    
    Всего попыток: ${attemptsPlayer1 + attemptsPlayer2}
  ''';

  print(stats);

  // Запись статистики в файл
  saveStats(stats);
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

void saveStats(String stats) {
  // Создаем каталог для статистики
  final directory = Directory('game_stats');
  if (!directory.existsSync()) {
    directory.createSync();
  }

  // Записываем статистику в файл с уникальным именем (например, с текущей датой и временем)
  final timestamp =
      DateTime.now().toString().replaceAll(':', '-').replaceAll(' ', '_');
  final file = File('game_stats/stats_$timestamp.txt');
  file.writeAsStringSync(stats);

  print("Статистика сохранена в файл ${file.path}");
}
