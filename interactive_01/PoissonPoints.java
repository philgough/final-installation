/**
 * ##library.name##
 * ##library.sentence##
 * ##library.url##
 *
 * Copyright ##copyright## ##author##
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 * 
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General
 * Public License along with this library; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 * Boston, MA  02111-1307  USA
 * 
 * @author      Phil Gough
 * @modified    ##date##
 * @version     0.2 (##library.version##)
 */

//package PoissonPoints;


import java.util.ArrayList;
import java.lang.Math.*;

import processing.core.*;
import processing.data.IntList;

/**
 * This is a template class and can be used to start a new processing library or tool.
 * Make sure you rename this class as well as the name of the example package 'template' 
 * to your own library or tool naming convention.
 * 
 * @example Hello 
 * 
 * @example return_PoissonPoints
 * 
 * (the tag @example followed by the name of an example included in folder 'examples' will
 * automatically include the example in the javadoc.)
 *
 */

public class PoissonPoints {
	


	public ArrayList <PoissonPoint> pp;
	public PVector[] ppLocations;
	public IntList checklist;
	
	public final static String VERSION = "##library.prettyVersion##";
	

	/**
	 * a Constructor, usually called in the setup() method in your sketch to
	 * initialize and start the library.
	 * 
	 * @example Hello
	 * @param theParent
	 */
	
	PApplet myParent;
	
	float maxNumPoints, minDist, testPoints, pointSize;
	
	public PoissonPoints(PApplet theParent, float tempMaxNumPoints, float tempMinDist, float tempTestPoints) {
		maxNumPoints = tempMaxNumPoints;
		minDist = tempMinDist;
		testPoints = tempTestPoints;
		
		myParent = theParent;

	  PVector firstPoint = new PVector((float) Math.random() * myParent.width, (float) Math.random() * myParent.height);
	  pp = new ArrayList<PoissonPoint>();
	  pp.add(new PoissonPoint(firstPoint, minDist, testPoints));
	  checklist = new IntList();
	  checklist.append(pp.size());

	  boolean found = false;

	  // println("while...");
	  while (activePoints() && pp.size() < maxNumPoints) {
	    // println("*** next while loop ***");
	    // select a random point from the list of all points

	    int r = (int) Math.floor(Math.random() * checklist.size());
	    int s = checklist.get(r);
	    PoissonPoint tpp = pp.get(s-1);

	    if(tpp.active) {
	      PVector point = tpp.location;
	      // println(" - - tpp.location:" + tpp.location);
	      found = false;
	      for (int i = 0; i < testPoints; i++) {
	        // println(" - - - testing a new point: " + i);
	        PVector newPoint = newRandomPoint(tpp.location, minDist);
	        if (checkPoints(newPoint, myParent.width, myParent.height)) {
	          pp.add(new PoissonPoint(newPoint, minDist, testPoints));
	          checklist.append(pp.size());
	          found = true;
	          i = (int) testPoints + 1;
	        }
	      }
	      if (!found) {
	        // println(" -*-*- deactivating -*-*- ");
	        tpp.active = false;
	        checklist.remove(r);
	      }

	    }

	  }



	  
		System.out.println("PoissonPoints 1.00 by PJ Gough");

		ppLocations = new PVector[pp.size()];
	  for (int i = 0; i < pp.size(); i++) {
	    PoissonPoint tpp = pp.get(i);
	     ppLocations[i] = tpp.location;
//	    System.out.println("set ppLocation:" + i);
	  }
		System.out.println("Distributed " + pp.size() + " points");// in " + n + " milliseconds");

	}
	

	// option to give xy dimensions
	public PoissonPoints(PApplet theParent, float tempMaxNumPoints, float tempMinDist, float tempTestPoints, float width, float height) {
		maxNumPoints = tempMaxNumPoints;
		minDist = tempMinDist;
		testPoints = tempTestPoints;
		
		myParent = theParent;

	  PVector firstPoint = new PVector((float) Math.random() * width, (float) Math.random() * height);
	  pp = new ArrayList<PoissonPoint>();
	  pp.add(new PoissonPoint(firstPoint, minDist, testPoints));
	  checklist = new IntList();
	  checklist.append(pp.size());

	  boolean found = false;

	  // println("while...");
	  while (activePoints() && pp.size() < maxNumPoints) {
	    // println("*** next while loop ***");
	    // select a random point from the list of all points

	    int r = (int) Math.floor(Math.random() * checklist.size());
	    int s = checklist.get(r);
	    PoissonPoint tpp = pp.get(s-1);

	    if(tpp.active) {
	      PVector point = tpp.location;
	      // println(" - - tpp.location:" + tpp.location);
	      found = false;
	      for (int i = 0; i < testPoints; i++) {
	        // println(" - - - testing a new point: " + i);
	        PVector newPoint = newRandomPoint(tpp.location, minDist);
	        if (checkPoints(newPoint, width, height)) {
	          pp.add(new PoissonPoint(newPoint, minDist, testPoints));
	          checklist.append(pp.size());
	          found = true;
	          i = (int) testPoints + 1;
	        }
	      }
	      if (!found) {
	        // println(" -*-*- deactivating -*-*- ");
	        tpp.active = false;
	        checklist.remove(r);
	      }

	    }

	  }



	  
		System.out.println("PoissonPoints 0.2 by PJ Gough");

		ppLocations = new PVector[pp.size()];
	  for (int i = 0; i < pp.size(); i++) {
	    PoissonPoint tpp = pp.get(i);
	     ppLocations[i] = tpp.location;
//	    System.out.println("set ppLocation:" + i);
	  }
		System.out.println("Distributed " + pp.size() + " points");// in " + n + " milliseconds");

	}
	// end 2nd constructor




	public PVector[] getPoints() {
		return ppLocations;
	}
	

	boolean activePoints() {
	  for (int i = 0; i < pp.size (); i++) {
	    PoissonPoint tpp = pp.get(i);
	    if (tpp.active) {
	      return true;
	    }
	  }
	  return false;
	}


	PVector newRandomPoint(PVector point, float minDist) {
	  float r1 = (float) Math.random() + 1;
	  float r2 = (float) Math.random();

	  float radius = minDist * r1;
	  float angle = PConstants.PI * 2 * r2;

	  float newX = point.x + radius * (float) Math.cos(angle);
	  float newY = point.y + radius * (float) Math.sin(angle);
	  PVector pv = new PVector(newX, newY);
	  return pv;
	}


	// boolean findNewPoint(PVector newPoint) {
	//   if (onScreen(newPoint) && !tooClose(newPoint)) {
	//     return true;
	//   }
	//   return false;
	// }

	boolean findNewPoint(PVector newPoint, float w, float h) {
	  if (inBounds(newPoint, w, h) && !tooClose(newPoint)) {
	    return true;
	  }
	  return false;
	}


	// boolean onScreen(PVector p) {
	//   return p.x >= 0 && p.y >= 0 && p.x <= myParent.width && p.y <= myParent.height;
	// }

	boolean inBounds(PVector p, float w, float h) {
	  return p.x >= 0 && p.y >= 0 && p.x <= w && p.y <= h;
	}

	boolean tooClose(PVector newPoint) {
	  for (int i = 0; i < pp.size (); i++) {
	    PoissonPoint tpp = pp.get(i);
	    if (PApplet.dist(newPoint.x, newPoint.y, tpp.x, tpp.y) < tpp.minDist) {
	      return true;
	    }
	  }
	  return false;
	}

	// boolean checkPoints (PVector newPoint){

	//   if (findNewPoint(newPoint)) {
	//     return true;
	//   } 
	//   else {
	//     return false;

	//   }
	// }

	boolean checkPoints (PVector newPoint, float w, float h){
		if (findNewPoint(newPoint, w, h)) {
			return true;
		} 
			return false;
		}	




	  public PVector getPPLocation (int i) {
		return ppLocations[i];
	  }
	  
	  public int numLocations () {
		  return ppLocations.length;
	  }

	/*
	*
	*	Class: PoissonPoint
	*
	*/

	class PoissonPoint {
	  float x, y;
	  int pixelArrayIndex;
	  PVector location;
	  float cellSize;
	  float minDist;
	  float testPoints;
	  boolean active = true;
	  PoissonPoint (float tx, float ty, float md, float tp) {
	    location = new PVector(tx, ty);
	    x = tx;
	    y = ty;
	    setVars(md, tp);
	  }
	  PoissonPoint (PVector p, float md, float tp) {
	    location = p;
	    x = p.x;
	    y = p.y;
	    setVars(md, tp);
	  }

	  void setVars(float md, float tp) {
	    minDist = md;
	    testPoints = tp;
	    cellSize = minDist/PApplet.sqrt(2);
	    pixelArrayIndex = imageToGrid();
	  }


	  PVector getPVector() {
	    PVector p = new PVector(x, y);
	    return p;
	  }

	  int imageToGrid() {
	    int gridX = (int)(location.x / cellSize);
	    int gridY = (int)(location.y / cellSize);

	    int i = gridX + gridY * myParent.width;
	    // println("imageToGrid index: " + i);
	    return i;
	  }
	}
	

}

	

	/* 
	private void welcome() {
		System.out.println("##library.name## ##library.prettyVersion## by ##author##");
	}
	
	
	public String sayHello() {
		return "hello library.";
	}
	/**
	 * return the version of the library.
	 * 
	 * @return String
	 /
	public static String version() {
		return VERSION;
	}

	/**
	 * 
	 * @param theA
	 *          the width of test
	 * @param theB
	 *          the height of test
	 /
	public void setVariable(int theA, int theB) {
		myVariable = theA + theB;
	}

	/**
	 * 
	 * @return int
	 /
	public int getVariable() {
		return myVariable;
	}
	*/