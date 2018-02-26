import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

public class Rosters implements Roster {

	// A Roster object represents a set of players.

	Set<Player> rosterSet = new HashSet<Player>();

	// Rosters.empty() is a static factory method that returns an
	// empty roster.

	public static Roster empty() {

		return new Rosters();

	}

	// Returns a roster consisting of the given player together
	// with all players on this roster.
	// Example:
	// r.with(p).with(p) => r.with(p)

	public Roster with(Player p) {

		Rosters newRoster = new Rosters();
		newRoster.rosterSet.addAll(rosterSet);
		newRoster.rosterSet.add(p);

		return newRoster;

	}

	// Returns a roster consisting of all players on this roster
	// except for the given player.
	// Examples:
	// Rosters.empty().without(p) => Rosters.empty()
	// r.without(p).without(p) => r.without(p)

	public Roster without(Player p) {

		Rosters newRoster = new Rosters();
		newRoster.rosterSet.addAll(rosterSet);
		newRoster.rosterSet.remove(p);

		return newRoster;

	}

	// Returns true iff the given player is on this roster.
	// Examples:
	//
	// Rosters.empty().has(p) => false
	//
	// If r is any roster, then
	//
	// r.with(p).has(p) => true
	// r.without(p).has(p) => false

	public boolean has(Player p) {
		return rosterSet.contains(p);
	}

	// Returns the number of players on this roster.
	// Examples:
	//
	// Rosters.empty().size() => 0
	//
	// If r is a roster with r.size() == n, and r.has(p) is false, then
	//
	// r.without(p).size() => n
	// r.with(p).size => n+1
	// r.with(p).with(p).size => n+1
	// r.with(p).without(p).size() => n

	public int size() {
		return rosterSet.size();
	}

	// Returns the number of players on this roster whose current
	// status indicates they are available.

	public int readyCount() {

		int count = 0;
		for (Player p : rosterSet) {
			if (p.available())
				count++;
		}
		return count;
	}

	// Returns a roster consisting of all players on this roster
	// whose current status indicates they are available.

	public Roster readyRoster() {

		Rosters newRoster = new Rosters();
		newRoster.rosterSet.addAll(rosterSet);

		Iterator<Player> it = newRoster.rosterSet.iterator();
		while (it.hasNext()) {
			Player value = it.next();
			if (!value.available())
				it.remove();
		}
		return newRoster;
	}

	// Returns an iterator that generates each player on this
	// roster exactly once, in alphabetical order by name.

	public Iterator<Player> iterator() {

		List<Player> sortedList = new ArrayList<Player>(rosterSet);
		Collections.sort(sortedList, new Compare());

		Iterator<Player> it = sortedList.iterator();

		return it;
	}

	// If r1 and r2 are rosters of different sizes, then
	// r1.toString() is not the same string as r2.toString().

	@Override
	public String toString() {

		return rosterSet.toString();
	}

	// If r1 and r2 are rosters, then r1.equals(r2) if and only if
	// every player on roster r1 is also on roster r2, and
	// every player on roster r2 is also on roster r1.

	@Override
	public boolean equals(Object x) {

		if (x instanceof Roster) {
			Roster r2 = (Roster) x;
			Iterator<Player> it1 = r2.iterator();
			Iterator<Player> it2 = this.iterator();
			while (it1.hasNext() && it2.hasNext()) {
				if (it1.next() != it2.next()) {
					return false;
				}
			}
			return it1.hasNext() == it2.hasNext();
		}

		return false;
	}

	// If r is a roster, then r.hashcode() always returns the same
	// value, even if r has some players whose status changes.

	// @Override
	// public int hashCode() {
	//
	// int hash = 0;
	// for (Player p : rosterSet) {
	// hash += p.hashCode();
	// }
	// return hash;
	// }

	@Override
	public int hashCode() {

		return rosterSet.hashCode();

	}

	public static void main(String[] args) {

		Roster r = Rosters.empty();
		Roster r1 = Rosters.empty();
		Player p1 = Players.make("A");
		Player p2 = Players.make("B");
		Player p3 = Players.make("D");
		Player p4 = Players.make("E");
		Player p5 = Players.make("C");
		p5.changeContractStatus(false);
		p2.changeContractStatus(false);

		Player p11 = Players.make("AAA");
		Player p12 = Players.make("ABA");
		Player p13 = Players.make("AAA");
		Player p14 = Players.make("AAB");
		Player p15 = Players.make("BAA");

		Roster r3 = Rosters.empty().with(p11).with(p12).with(p13).with(p14).with(p15);

		r = r.with(p5).with(p4).with(p1).with(p2).with(p3);
		r1 = r.with(p1);

		int rHash = r.hashCode();

		Iterator<Player> it = r3.iterator();
		Roster r4 = Rosters.empty();

		while (it.hasNext()) {
			Player value = it.next();
			r4 = r4.with(value);
			
		}

		assert r3.equals(r4) : "r1 is not equal to r3";
		assert r.hashCode() == rHash : "Roster is immutable";
		
		assert r.hashCode() == r1.hashCode() : "Error in hashCode";

		assert r.hashCode() != Rosters.empty().hashCode() : "Error in hashCode";

		assert r.equals(r1) == true : "Error in equals";

		r.without(p5);

		assert r.has(p5) : "r has p5";

		assert Rosters.empty().has(p5) == false : "It is an empty roster";

		assert r.with(p5).with(p4).with(p1).with(p2).with(p3).equals(r1) : "Roster should not have duplicate players";

		assert r.readyRoster().equals(r1.without(p5).without(p2)) : "Roster should be immutable";

		assert r.readyCount() == 3 : "Ready count is 3";

		assert Rosters.empty().size() == 0 : "Size of empty roster is 0";

		assert r.size() == 5 : "size of r is 5";

		assert r.hashCode() == rHash : "Roster is immutable";

		System.out.println("All tests passed!");

	}
}
