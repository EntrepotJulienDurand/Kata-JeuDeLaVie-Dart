import 'dart:math';

import 'package:jeu_de_la_vie/jeu_de_la_vie.dart';
import 'package:test/test.dart';

void main() {
  group('Any live cell with fewer than two live neighbours dies', () {
    test('Une cellule peut etre vivante', () {
      expect(Cell.alive().isAlive, true);
    });

    test('Une cellule peut etre morte', () {
      expect(Cell.dead().isAlive, false);
    });

    test('Une cellule morte peut vivre', () {
      var cell = Cell.dead();
      cell.live();
      expect(cell.isAlive, true);
    });

    test('une cellule vivante peut mourir', () {
      var cell = Cell.alive();
      cell.die();
      expect(cell.isAlive, false);
    });

    test('une cellule peut avoir des voisins vivants', () {
      var jeuDeLaVie = GameOfLife(4, 8);
      jeuDeLaVie.setAliveCell(0, 0);
      jeuDeLaVie.setAliveCell(1, 1);

      expect(jeuDeLaVie.getAliveNeighbours(0, 0).length, equals(1));
    });

    test('une cellule est vivantes si au moins deux voisins sont vivants', () {
      var jeuDeLaVie = GameOfLife(4, 8);
      jeuDeLaVie.setAliveCell(1, 1);
      jeuDeLaVie.setAliveCell(1, 2);
      jeuDeLaVie.setAliveCell(2, 2);

      jeuDeLaVie.nextGeneration();

      expect(jeuDeLaVie.getCell(0,0).isAlive, false);
      expect(jeuDeLaVie.getCell(2,2).isAlive, true);
      expect(jeuDeLaVie.getCell(1,1).isAlive, true);
      expect(jeuDeLaVie.getCell(1,2).isAlive, true);
    });
  });
}

enum CellState {
  ALIVE,
  DEAD;
}

class GameOfLife {
  var cells;

  int _rowNumbers;
  int _columnNumbers;

  GameOfLife(this._rowNumbers, this._columnNumbers) {
    this.cells = List.generate(
      _rowNumbers,
      (x) => List.generate(_columnNumbers, (y) => Cell.dead()),
    );
  }

  setAliveCell(int x, int y) => cells[x][y].live();

  List<Cell> getAliveNeighbours(int x, int y) {
    List<Cell> aliveNeigbours = [];

    addToNeigbours(int x, int y) {
      if (x < 0 || x >= _rowNumbers || y < 0 || y >= _columnNumbers) {
        return;
      }

      var cell = cells[x][y];

      if (cell != null && cell.isAlive) {
        aliveNeigbours.add(cell);
      }
    }

    addToNeigbours(x - 1, y);
    addToNeigbours(x - 1, y + 1);
    addToNeigbours(x, y - 1);
    addToNeigbours(x + 1, y);
    addToNeigbours(x + 1, y - 1);
    addToNeigbours(x, y + 1);
    addToNeigbours(x + 1, y + 1);

    return aliveNeigbours;
  }

  Cell getCell(int x, int y)=>cells[x][y];

  void nextGeneration() {
    for(int row=0;row<_rowNumbers; row++){
      for(int col=0;col<_columnNumbers;col++){
        var nbNeighboursAlive = getAliveNeighbours(row, col).length;
        print('x:$row y:$col, voisins vivants : $nbNeighboursAlive');
        if(nbNeighboursAlive<2){
          cells[row][col].die();
          //print('x:$row, y:$col meurt de décès');
        }
      }
    }
  }
}

class Cell {
  CellState state;

  Cell({required this.state});

  Cell.dead() : this(state: CellState.DEAD);

  Cell.alive() : this(state: CellState.ALIVE);

  bool get isAlive => state == CellState.ALIVE;

  die() => state = CellState.DEAD;

  live() => state = CellState.ALIVE;
}
