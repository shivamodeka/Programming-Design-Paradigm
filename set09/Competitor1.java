// Constructor template for Competitor1:
//     new Competitor1 (Competitor c1)
//
// Interpretation: the competitor represents an individual or team

// Note:  In Java, you cannot assume a List is mutable, because all
// of the List operations that change the state of a List are optional.
// Mutation of a Java list is allowed only if a precondition or other
// invariant says the list is mutable and you are allowed to change it.

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;



class Competitor1 implements Competitor {

    String name;

    Competitor1 (String s) {

        this.name = s;

    }

    // returns the name of this competitor

    public String name () {

        return name;

    }

    // GIVEN: another competitor and a list of outcomes
    // RETURNS: true iff one or more of the outcomes indicates this
    //     competitor has defeated or tied the given competitor
    // EXAMPLE: A.hasDefeated(B, [Defeat1(A,B)]) => true

    public boolean hasDefeated (Competitor c2, List<Outcome> outcomes) {

        for (Outcome i : outcomes) {

        	if (!i.isTie() && i.winner().name() == this.name() && i.loser().name() == c2.name())
        		return true;
        	else if (i.isTie() && i.first().name() == this.name() && i.second().name() == c2.name())
        		return true;
        	else if (i.isTie() && i.second().name() == this.name() && i.first().name() == c2.name())
        		return true;

        }

		return false;

    }

    // GIVEN: a list of outcomes
    // RETURNS: a list of the names of all competitors mentioned by
    //     the outcomes that are outranked by this competitor,
    //     without duplicates, in alphabetical order
    // EXAMPLES: A.outranks(outcomes) => ("B", "C",
    // "D", "E", "H", "L", "P", "Q", "S", "X")

    public List<String> outranks (List<Outcome> outcomes) {

    		String j;

        List <String> outranks = new ArrayList<String>();

			for (Outcome i : outcomes) {

		        	if (!i.isTie() && i.winner().name() == this.name()) {
		        		j = i.loser().name();
		        		if (!outranks.contains(j))
		        			outranks.add(j);
		        	}

		        	else if (i.isTie() && i.first().name() == this.name()){
		        		j = i.second().name();
		        		if (!outranks.contains(j))
		        			outranks.add(j);
		        	}

		        	else if (i.isTie() && i.second().name() == this.name()){
		        		j = i.first().name();
		        		if (!outranks.contains(j))
		        			outranks.add(j);
		        }
		       }


       for (int k = 0; k < outranks.size(); ++k) {

    	   	for (Outcome i : outcomes) {

        	if (!i.isTie() && i.winner().name() == outranks.get(k)) {
        		j = i.loser().name();
        		if (!outranks.contains(j))
        			outranks.add(j);
        	}

        	else if (i.isTie() && i.first().name() == outranks.get(k)){
        		j = i.second().name();
        		if (!outranks.contains(j))
        			outranks.add(j);
        	}

        	else if (i.isTie() && i.second().name() == outranks.get(k)){
        		j = i.first().name();
        		if (!outranks.contains(j))
        			outranks.add(j);
        }
       }
      }

        Collections.sort (outranks);
        return outranks;

    }


    // GIVEN: a list of outcomes
    // RETURNS: a list of the names of all competitors mentioned by
    //     the outcomes that outrank this competitor,
    //     without duplicates, in alphabetical order
    // EXAMPLES: A.outrankedBy(outcomes) => ("T")

    public List<String> outrankedBy (List<Outcome> outcomes) {

    	String j;

        List <String> outrankedBy = new ArrayList<String>();

			for (Outcome i : outcomes) {

		        	if (!i.isTie() && i.loser().name() == this.name()) {
		        		j = i.winner().name();
		        		if (!outrankedBy.contains(j))
		        		outrankedBy.add(j);
		        	}

		        	else if (i.isTie() && i.first().name() == this.name()){
		        		j = i.second().name();
		        		if (!outrankedBy.contains(j))
		        		outrankedBy.add(j);
		        	}

		        	else if (i.isTie() && i.second().name() == this.name()){
		        		j = i.first().name();
		        		if (!outrankedBy.contains(j))
		        		outrankedBy.add(j);
		        }
		       }


       for (int k = 0; k < outrankedBy.size(); ++k) {

        for (Outcome i : outcomes) {

        	if (!i.isTie() && i.loser().name() == outrankedBy.get(k)) {
        		j = i.winner().name();
        		if (!outrankedBy.contains(j))
        			outrankedBy.add(j);
        	}

        	else if (i.isTie() && i.first().name() == outrankedBy.get(k)){
        		j = i.second().name();
        		if (!outrankedBy.contains(j))
        			outrankedBy.add(j);
        	}

        	else if (i.isTie() && i.second().name() == outrankedBy.get(k)){
        		j = i.first().name();
        		if (!outrankedBy.contains(j))
        			outrankedBy.add(j);
        }
       }
      }

        Collections.sort (outrankedBy);
        return outrankedBy;


    }

 // GIVEN: a competitor and a list of outcomes
    // RETURNS: the non-losing percentage of the competitor
    // EXAMPLE: nlp(B, outcomes) => 0.5

    private double nlp (Competitor c1, List<Outcome> outcomes) {

    		double n = 0;
    		double total = 0;

    		for (Outcome i : outcomes) {
    			if (!i.isTie() && i.winner() == c1)
    				n ++;
    			else if (i.isTie() && i.first() == c1)
    				n++;
    			else if (i.isTie() && i.second() == c1)
    				n++;
    		}

    		for (Outcome i : outcomes) {
    			if (!i.isTie() && (i.winner() == c1 || i.loser() == c1))
    				total++;
    			else if (i.isTie() && i.first() == c1)
    				total++;
    			else if (i.isTie() && i.second() == c1)
    				total++;
    		}
    		return n/total;
    }

    // GIVEN: a list of outcomes
    // RETURNS: a list of the names of all competitors mentioned by
    //     one or more of the outcomes, without repetitions, with
    //     the name of competitor A coming before the name of
    //     competitor B in the list if and only if the power-ranking
    //     of A is higher than the power ranking of B.
    // EXAMPLE: powerRanking(outcomes) => (C,D,E,F,B,D)

    public List<String> powerRanking (List<Outcome> outcomes) {

        List<String> powerRanking = new ArrayList<String>();
        List<Competitor> compList = new ArrayList<Competitor>();

        compList = createCompList(outcomes);

        mergeSort(compList, outcomes);

        for (Competitor k : compList)
        	powerRanking.add(k.name());

        return powerRanking;

    }


 // GIVEN: a list of outcomes
    // RETURNS: a list of all the competitors mentioned by
    //     one or more of the outcomes, without repetitions
    // EXAMPLE: createCompList (List (Defeat1 (A, B)) Defeat1(C, D)) =>
    //          (A, B, C, D)

    private List<Competitor> createCompList (List<Outcome> outcomes){

    		List<Competitor> compList = new ArrayList<Competitor>();

        for (Outcome i : outcomes) {
        	if (!i.isTie() && !compList.contains(i.winner()) && !compList.contains(i.loser())) {
        		compList.add(i.winner());
        		compList.add(i.loser());
        	}
        	else	if (i.isTie() && !compList.contains(i.first()) && !compList.contains(i.second())) {
        		compList.add(i.first());
        		compList.add(i.second());
        	}

        	else	if (!i.isTie() && !compList.contains(i.winner()))
        		compList.add(i.winner());
        	else	if (!i.isTie() && !compList.contains(i.loser()))
        		compList.add(i.loser());
        	else	if (i.isTie() && !compList.contains(i.first()))
        		compList.add(i.first());
        	else	if (i.isTie() && !compList.contains(i.second()))
        		compList.add(i.second());
        }

        return compList;

    }

 // GIVEN: a list of competitors and a list of outcomes
 // RETURNS: a list of all the competitors sorted based on
 //  their power-ranking using merge-sort algorithm
 // EXAMPLE: mergeSort(List (A,B,,C,D)) = > (C,D,B,A)


    private void mergeSort (List<Competitor> compList, List<Outcome> outcomes){

    		int n = compList.size();

    		if (n < 2) return;

    		int midPoint = n/2;

    		List<Competitor> left = new ArrayList<Competitor>(midPoint);
    		List<Competitor> right = new ArrayList<Competitor>(n - midPoint);

    		for (int i = 0; i < midPoint; i++)
    			left.add(i, compList.get(i));

    		for (int i = midPoint; i < n; i++)
    			right.add(i - midPoint, compList.get(i));

    		mergeSort(left, outcomes);
    		mergeSort(right, outcomes);
    		merge(left, right, compList, outcomes);
    }

 // GIVEN: two lists of competitors and a list of outcomes
    // RETURNS: a single merged list of all the competitors sorted based on
    //  their power-ranking using merge-sort algorithm
    // EXAMPLE: merge(list(A,D) list (B,C) (list A,B,C,D) (outcomes)) =>
    // (C,D,B,A)

    private void merge(List<Competitor> left, List<Competitor> right, List<Competitor> compList, List<Outcome> outcomes) {

		int nl = left.size();
		int nr = right.size();
		int i = 0;
		int j = 0;
		int k = 0;

      // HALTING MEASURE: (nl-i) + (nr-j)
			while (i < nl && j < nr) {
				if (powerSort(left.get(i), right.get(j), outcomes)) {

					compList.set(k, left.get(i));
					i++;
					k++;
				}
				else {
					compList.set(k, right.get(j));
					j++;
					k++;
				}
			}

      // HALTING MEASURE: nl-i
			while (i < nl) {
				compList.set(k, left.get(i));
				i++;
				k++;
			}

      // HALTING MEASURE: nr-j
			while (j < nr) {
				compList.set(k, right.get(j));
				j++;
				k++;
			}


	}

 // GIVEN: two competitors and a list of outcomes
    // RETURNS: true iff the name of competitor A comes before the name of
    //     competitor B when the power-ranking
    //     of A is higher than the power ranking of B.
    // EXAMPLE: powerSort (A,B) => true

	private Boolean powerSort (Competitor c1, Competitor c2, List<Outcome> outcomes) {

    		if (c1.outrankedBy(outcomes).size() < c2.outrankedBy(outcomes).size())
    			return true;
    		else if (c1.outrankedBy(outcomes).size() == c2.outrankedBy(outcomes).size()
                  && c1.outranks(outcomes).size() > c2.outranks(outcomes).size())
    			return true;
    		else if (c1.outrankedBy(outcomes).size() == c2.outrankedBy(outcomes).size()
                  && c1.outranks(outcomes).size() == c2.outranks(outcomes).size()
    				      && nlp(c1, outcomes) > nlp(c2, outcomes))
    			return true;
    		else if (c1.outrankedBy(outcomes).size() == c2.outrankedBy(outcomes).size()
                  && c1.outranks(outcomes).size() == c2.outranks(outcomes).size()
    				      && nlp(c1, outcomes) == nlp(c2, outcomes)
                  && c1.name().compareTo(c2.name()) < c2.name().compareTo(c1.name()))
    			return true;
    		else return false;

    }


    public static void main(String[] args) {

    	List<Outcome> outcomes = new ArrayList<Outcome>();
      
  Competitor A = new Competitor1("A");
  Competitor B = new Competitor1("B");
  Competitor C = new Competitor1("C");
  Competitor D = new Competitor1("D");
	Competitor E = new Competitor1("E");
  Competitor F = new Competitor1("F");
	Competitor G = new Competitor1("G");
	Competitor H = new Competitor1("H");
	Competitor I = new Competitor1("I");
	Competitor J = new Competitor1("J");
	Competitor K = new Competitor1("K");
	Competitor L = new Competitor1("L");
	Competitor M = new Competitor1("M");
	Competitor N = new Competitor1("N");
	Competitor P = new Competitor1("P");
	Competitor Q = new Competitor1("Q");
	Competitor R = new Competitor1("R");
	Competitor S = new Competitor1("S");
	Competitor T = new Competitor1("T");
	Competitor U = new Competitor1("U");
	Competitor V = new Competitor1("V");
	Competitor W = new Competitor1("W");
	Competitor X = new Competitor1("X");
	Competitor Y = new Competitor1("Y");
	Competitor Z = new Competitor1("Z");

		Outcome o1 = new Defeat1(A, B);
		Outcome o2 = new Defeat1(B, C);
		Outcome o3 = new Defeat1(C, D);
		Outcome o4 = new Tie1(D, E);
		Outcome o5 = new Defeat1(E, H);
		Outcome o6 = new Tie1(F, I);
		Outcome o7 = new Tie1(G, K);
		Outcome o8 = new Defeat1(H, L);
		Outcome o9 = new Defeat1(I, M);
		Outcome o10 = new Tie1(J, N);
		Outcome o11 = new Tie1(P, B);
		Outcome o12 = new Tie1(C, E);
		Outcome o13 = new Defeat1(J, P);
		Outcome o14 = new Tie1(Q, P);
		Outcome o15 = new Defeat1(R, K);
		Outcome o16 = new Tie1(S, L);
		Outcome o17 = new Defeat1(T, A);
		Outcome o18 = new Defeat1(U, B);
		Outcome o19 = new Defeat1(V, E);
		Outcome o20 = new Defeat1(W, P);
		Outcome o21 = new Tie1(X, B);
		Outcome o22 = new Defeat1(Y, E);
		Outcome o23 = new Defeat1(Z, P);
		Outcome o24 = new Defeat1(A, B);



    	outcomes.add(o1);
    	outcomes.add(o2);
    	outcomes.add(o3);
    	outcomes.add(o4);
    	outcomes.add(o5);
    	outcomes.add(o6);
    	outcomes.add(o7);
    	outcomes.add(o8);
    	outcomes.add(o9);
    	outcomes.add(o10);
    	outcomes.add(o11);
    	outcomes.add(o12);
    	outcomes.add(o13);
    	outcomes.add(o14);
    	outcomes.add(o15);
    	outcomes.add(o16);
    	outcomes.add(o17);
    	outcomes.add(o18);
    	outcomes.add(o19);
    	outcomes.add(o20);
    	outcomes.add(o21);
    	outcomes.add(o22);
    	outcomes.add(o23);
    	outcomes.add(o24);


      assert X.hasDefeated(B, outcomes) == true : "Check hasdefeated?";
      assert A.name() == "A" : "incorrect name";
      assert A.hasDefeated(B, outcomes) == true : "Check hasdefeated?";
      assert o21.isTie() == true : "error in istie?";
      assert o24.isTie() == false : "error in istie?";
      assert o24.winner().name() == "A" : "Error in winner";
      assert o24.loser().name() == "B" : "Error in loser";
      assert o24.first().name() == "A" : "Error in first";
      assert o24.second().name() == "B" : "Error in second";
      assert A.outranks(outcomes).equals(new ArrayList<>(Arrays.asList("B", "C",
       "D", "E", "H", "L", "P", "Q", "S", "X")))
    								: "Outranks incorrect";
    	assert B.outranks(outcomes).equals(new ArrayList<>(Arrays.asList("B", "C",
       "D", "E", "H", "L", "P", "Q", "S", "X")))
    								: "Outranks incorrect";
    	assert A.outrankedBy(outcomes).equals(new ArrayList<>(Arrays.asList("T")))
    								: "OutrankedBy incorrect";
    	assert B.outrankedBy(outcomes).equals(new ArrayList<>(Arrays.asList("A",
      "B", "J", "N", "P", "Q", "T", "U", "W", "X", "Z")))
    								: "OutrankedBy incorrect";
      assert A.powerRanking(outcomes).equals(new ArrayList<>(Arrays.asList("T",
      "U", "W", "Z", "V", "Y", "R", "A", "J", "N","F", "I", "M", "G", "K", "Q",
      "X", "B", "P", "C", "E", "D", "H", "S" , "L")))
      								: "Power ranking incorrect";


      System.out.println("All tests passed!");

	}
}
