<?php
/**
 * CARD DISTRIBUTOR
 * 
 * Purpose: Distributes 52 cards to N people
 * Usage: Call distribute($numPeople) where $numPeople > 0
 * 
 * Remarks:
 * - Cards are distributed evenly (even the number of people is more than 52)
 */
class CardDistributor {
    private $suits = ['S', 'H', 'D', 'C'];
    private $values  = [1=>'A', 2=>'2', 3=>'3', 4=>'4', 5=>'5',6=>'6', 7=>'7', 8=>'8', 9=>'9', 10=>'X',11=>'J', 12=>'Q', 13=>'K'];

    public function distribute(int $numPeople): array {
        // Create deck
        $deck = [];
        foreach($this->suits as $suit) {
            foreach($this->values as $num => $val) {
                $deck[] = $suit . '-' . $val;
            }
        }

        // To randomize the deck
        for ($i = 0; $i < 52; $i++) {
            $randomIndex = rand(0, 51);
            $temp = $deck[$i];
            $deck[$i] = $deck[$randomIndex];
            $deck[$randomIndex] = $temp;
        }

        // Distribute cards
        $result = array_fill(0, $numPeople, []);
        $i = 0;
        foreach($deck as $card) {
            $result[$i % $numPeople][] = $card;
            $i++;
        }
        
        return $result;
    }
}
?>