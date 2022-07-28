import java.util.ArrayList;
import java.util.List;

import com.google.ortools.Loader;
import com.google.ortools.sat.CpModel;
import com.google.ortools.sat.CpSolver;
import com.google.ortools.sat.CpSolverStatus;
import com.google.ortools.sat.IntVar;
import com.google.ortools.sat.IntervalVar;
import com.google.ortools.sat.LinearExpr;
import com.google.ortools.sat.ReservoirConstraint;

/*
 * An example of Reservoir constraints.
 * 
 * A set of Jobs all need to be performed.  Varying time required to complete each Job (the 'duration'.)
 * We can only work on a maximum of X Jobs at once ('maxConcurrentJobs'.)
 * 
 * What order should we work on the jobs such that they'll all be completed as early as possible?
 */
public class ReservoirExample {

	public static class Job {

		public int id;

		IntVar start;

		IntervalVar interval;

		public static final int MIN_BEGIN = 0;
		public static final int MAX_END = 100;

		public Job(int id, long duration, CpModel model) {

			this.id = id;

			String name = "Job ID: " + id + " (duration: " + duration + ")";

			start = model.newIntVar(MIN_BEGIN, MAX_END, name + " Start");

			interval = model.newFixedSizeIntervalVar(start, duration, name);
		}

		public LinearExpr getStartExpr() {
			return interval.getStartExpr();
		}

		public LinearExpr getEndExpr() {
			return interval.getEndExpr();
		}
	}

	public static void main(String[] args) throws Exception {
		Loader.loadNativeLibraries();
	    CpModel model = new CpModel();

	    // The Jobs.  (Sample data.)
	    List<Job> jobs = new ArrayList<Job>();
		jobs.add(new Job(1, 1, model));
		jobs.add(new Job(2, 2, model));
		jobs.add(new Job(3, 2, model));
		jobs.add(new Job(4, 3, model));
		jobs.add(new Job(5, 3, model));
		jobs.add(new Job(6, 3, model));
		jobs.add(new Job(7, 4, model));
		jobs.add(new Job(8, 4, model));
		jobs.add(new Job(9, 4, model));
		jobs.add(new Job(10, 4, model));

	    // Maximum number of Jobs being done concurrently.
		int maxConcurrentJobs = 3;
		ReservoirConstraint reservoir = model.addReservoirConstraint(0, maxConcurrentJobs);
	    for( Job job : jobs) {
	    	// Each Job's start adds one "level" to the reservoir.
	    	reservoir.addEvent(job.getStartExpr(), 1);

	    	// Each Job's start removes one "level" from the reservoir.
	    	reservoir.addEvent(job.getEndExpr(), -1);
	    }

		// It's easy to get an OPTIMAL solution over a long horizon when Reservoir min
		// is 0. (Just do each Job one at a time.)

		// Optimize for the earliest time that *all* Jobs could be complete.
	    List<LinearExpr> endExprs = new ArrayList<LinearExpr>();
	    for( Job job : jobs) {
	    	endExprs.add(job.getEndExpr());
	    }
		IntVar latestJobEnd = model.newIntVar(Job.MIN_BEGIN, Job.MAX_END, "Latest Job End");
	    model.addMaxEquality(latestJobEnd, endExprs);
	    model.minimize(latestJobEnd);

	    // Creates a solver and solve the model.
	    CpSolver solver = new CpSolver();
	    solver.getParameters().setMaxTimeInSeconds(100).setNumWorkers(16);
	    CpSolverStatus status = solver.solve(model);

		// Display the solution.
	    System.out.println("status: " + status);
	    if (status == CpSolverStatus.OPTIMAL || status == CpSolverStatus.FEASIBLE) {
	    	System.out.println("latestJobEnd: " + solver.value(latestJobEnd));
		    for( Job job : jobs) {
				System.out.println(job.id + " - Start: " + solver.value(job.getStartExpr()) +
		    			" End: " + solver.value(job.getEndExpr()));
		    }
	    }
	}
}
