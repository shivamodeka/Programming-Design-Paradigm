
//unit tests for RosterWithStream1

import java.util.Arrays;
import java.util.Iterator;

public class TestRosterWithStream {

	public static void main(String[] args) {

		// calling factory method empty() to create an object of RosterWithStream
		RosterWithStream r = RosterWithStreams.empty();
		RosterWithStream r1 = RosterWithStreams.empty();

		// Creating players using factory method make()
		Player p1 = Players.make("ABC");
		Player p2 = Players.make("AB");
		Player p3 = Players.make("ABCD");
		Player p4 = Players.make("B");
		Player p5 = Players.make("A");

		// adding same players into r and r1
		r = r.with(p5).with(p4).with(p1).with(p2).with(p3);
		r1 = r1.with(p1).with(p3).with(p5).with(p2).with(p4);

		////////////////////////////////////////////////////////////////////////////////////
		//                              TESTS FOR METHODS                                //
		///////////////////////////////////////////////////////////////////////////////////

		// r and r1 have same players
		assert r.equals(r1) == true : "Error in equals";

		// equal rosters have equal hash codes
		assert r.hashCode() == r1.hashCode() : "Error in hashCode";

		int rHash = r.hashCode();

		Player p6 = Players.make("X");
		r.with(p6); // adding another player to r

		assert r.hashCode() == rHash : "Roster should be immutable"; // hash code remains the same

		assert r.hashCode() != RosterWithStreams.empty().hashCode() : "Error in hashCode";

		r.without(p5);

		// test for has
		assert r.has(p5) : "r has p5";

		assert RosterWithStreams.empty().has(p5) == false : "It is an empty roster";

		// tests for duplicate players
		assert r.with(p5).with(p4).with(p1).with(p2).with(p3).equals(r1) : "Roster should not have duplicate players";

		p2.changeContractStatus(false);
		p5.changeContractStatus(false);
		assert r.readyRoster().equals(r.without(p5).without(p2)) : "Ready roster contains players that are available";

		// test for ready count
		assert r.readyCount() == 3 : "Ready count is 3";

		// test for size
		assert RosterWithStreams.empty().size() == 0 : "Size of empty roster is 0";
		
		assert r.size() == 5 : "size of r is 5";
		
		Player p7 = Players.make("A");
		
		// adding another player to r with the same name as an existing player

		assert r.with(p7).size() == 6 : "size of r is now 6";

		assert r.hashCode() == rHash : "Roster is immutable"; // r remains unchanged after all the operations

		////////////////////////////////////////////////////////////////////////////////////
		//                                TESTS WITH STREAM                              //
		///////////////////////////////////////////////////////////////////////////////////

		// use forEach to change the status of each player to available
		r.stream().forEach(p -> p.changeContractStatus(true));
		
		// test for allMatch when true
		assert r.stream().allMatch(p -> p.available()) == true : "Test for allMatch true";
		
		p1.changeContractStatus(false);
		// test for allMatch when false
		assert r.stream().allMatch(p -> p.available()) == false : "Test for allMatch false";

		// test for filter against ready count
		assert r.stream().filter((Player p) -> p.available()).count() == r.readyCount() : "Test for filter";

		// test for anyMatch when true
		assert r.stream().anyMatch(p -> p.available()) == true : "Test for anyMatch true";

		// use forEach to change the status of each player to not available
		r.stream().forEach(p -> p.changeContractStatus(false));
		
		// test for anyMatch when false
		assert r.stream().anyMatch(p -> p.available()) == false : "Test for anyMatch false";

		// use forEach to change the status of each player back to available
		r.stream().forEach(p -> p.changeContractStatus(true));
		assert r.stream().allMatch(p -> p.available()) == true : "Test for forEach";

		// test for count against size()
		assert r.stream().count() == r.size() : "Test for count";

		// use map to get the length of name of each player
		Iterator<Integer> rit = r.stream().map(p -> p.name().length()).iterator();
		Iterator<Player> pit = r.iterator();

		// test map
		while (rit.hasNext() && pit.hasNext()) {

			int streamValue = rit.next();
			int rosterValue = pit.next().name().length();
			assert streamValue == rosterValue : "Test for map";

		}

		// calculate the sum of length of names of the players
		int countNameLength = 0;
		for (Player p : r) {
			countNameLength = countNameLength + p.name().length();
		}

		// use map to get the length of name of each player and reduce to sum it into a
		// single integer
		assert r.stream().map(p -> p.name().length()).reduce(0, (a, b) -> a + b)
				.intValue() == countNameLength : "Test for reduce";

		// this.stream and this.stream.distinct should be equal
		Iterator<Player> it1 = r.stream().iterator();
		Iterator<Player> it2 = r.stream().distinct().iterator();

		while (it1.hasNext() && it2.hasNext()) {

			Player streamPlayer = it1.next();
			Player rosterPlayer = it2.next();

			assert streamPlayer.equals(rosterPlayer) : "Test for distinct";
		}

		assert r.stream().findFirst().get().equals(p5) : "Test for findFirst";

		// findAny should return a player which is on this roster
		assert r.has(r.stream().findAny().get()) : "Test for findAny";

		// to store the stream into an array
		Player[] myNewArray1 = r.stream().skip(2).toArray(Player[]::new);

		// create an array to test
		Player[] myTestArray1 = new Player[] { p1, p3, p4 };

		// compare the two arrays
		assert Arrays.equals(myNewArray1, myTestArray1) : "Test for skip";

		Player[] myNewArray2 = r.stream().toArray(Player[]::new);

		Player[] myTestArray2 = new Player[] { p5, p2, p1, p3, p4 };

		assert Arrays.equals(myNewArray2, myTestArray2) : "Test for toArray";

		System.out.println("All tests passed!");

	}

}
