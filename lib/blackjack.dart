import 'dart:io';

void main() {
  stdout.writeln('***********************************************************');
  stdout.writeln('\t\t\tДобро пожаловать в игру блек-джек!');
  stdout.writeln('***********************************************************');
  final deck = Deck();

  final player = Player();
  final dealer = Player();

  bool isShowTitle = true;
  while (true) {
    if (isShowTitle) {
      setupPlayers(deck, player, dealer);
      isShowTitle = false;
    }
    stdout.writeln('Ваш ход (1 - Взять, 2 - Пас):');
    final input = stdin.readLineSync();
    if (input == '1') {
      player.addCard(deck.drawCard());
      stdout.writeln('Ваши карты: ${player.hand}');
      if (player.isBust()) {
        stdout.writeln('--->Вы проиграли!<---');
        return;
      }
    } else if (input == '2') {
      bool isShow = true;
      while (dealer.getScore() < 17) {
        isShow = false;
        stdout.writeln('Ход Дилера:');
        dealer.addCard(deck.drawCard());
        stdout.writeln('Дилер: ${dealer.hand}');
      }
      if(isShow) {
        stdout.writeln('Дилер: ${dealer.hand}');
      }
      if (dealer.isBust() || player.getScore() > dealer.getScore()) {
        stdout.writeln('--->Вы победили!<---');
      } else if (player.getScore() < dealer.getScore()) {
        stdout.writeln('--->Вы проиграли.<---');
      } else {
        stdout.writeln('--->Ничья!<---');
      }
      stdout.writeln('Играть еще? (y/n)');
      final input = stdin.readLineSync();
      if (input?.toLowerCase() !='y') {
        break;
      }
      dealer.clearCard();
      player.clearCard();
      isShowTitle = true;
    }
  }
  stdout.writeln('****************************');
  stdout.writeln('\t\tДо свидания!');
  stdout.writeln('****************************');
}

void setupPlayers(Deck deck, Player player, Player dealer) {
  deck.shuffle();
  player.addCard(deck.drawCard());
  dealer.addCard(deck.drawCard());
  player.addCard(deck.drawCard());
  dealer.addCard(deck.drawCard());
  stdout.writeln('Раздача:');
  stdout.writeln('Дилер: ${dealer.hand[0]} -');
  stdout.writeln('Ваши карты: ${player.hand}');
}

class Deck {
  static const suits = ['♥︎', '♦︎', '♣︎', '♠︎'];
  static const ranks = [
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    'J',
    'Q',
    'K',
    'A'
  ];

  final List<Card> _cards = [];

  Deck() {
    for (final suit in suits) {
      for (final rank in ranks) {
        _cards.add(Card(suit, rank));
      }
    }
  }

  void shuffle() {
    _cards.shuffle();
  }

  Card drawCard() {
    return _cards.removeLast();
  }
}

class Card {
  final String suit;
  final String rank;

  Card(this.suit, this.rank);

  @override
  String toString() {
    return '$rank$suit';
  }

  int getValue() {
    switch (rank) {
      case 'A':
        return 11;
      case 'K':
      case 'Q':
      case 'J':
        return 10;
      default:
        return int.parse(rank);
    }
  }
}

class Player {
  final List<Card> hand = [];

  void addCard(Card card) {
    hand.add(card);
  }

  void clearCard(){
    hand.clear();
  }

  int getScore() {
    var score = 0;
    var aceCount = 0;
    for (final card in hand) {
      score += card.getValue();
      if (card.rank == 'A') {
        aceCount++;
      }
    }
    while (score > 21 && aceCount > 0) {
      score -= 10;
      aceCount--;
    }
    return score;
  }

  bool isBust() {
    return getScore() > 21;
  }
}