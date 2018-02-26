// Constructor template for Tie1:
//     new Defeat1 (Competitor c1, Competitor c2)
// Interpretation:
//     c1 and c2 have engaged in a contest that ended with
//         c1 defeating c2

public class Defeat1 implements Outcome {

    Competitor c1;
    Competitor c2;

    Defeat1 (Competitor c1, Competitor c2) {

    		this.c1 = c1;
        this.c2 = c2;

    }

    // RETURNS: true iff this outcome represents a tie

    public boolean isTie () {

        return false;
   

    }

    // RETURNS: one of the competitors

    public Competitor first () {

       return c1;

    }

    // RETURNS: the other competitor

    public Competitor second () {

       return c2;

    }

    // GIVEN: no arguments
    // WHERE: this.isTie() is false
    // RETURNS: the winner of this outcome

    public Competitor winner () {

       return c1;

    }

    // GIVEN: no arguments
    // WHERE: this.isTie() is false
    // RETURNS: the loser of this outcome

    public Competitor loser () {

        return c2;
    }
    
    
}

