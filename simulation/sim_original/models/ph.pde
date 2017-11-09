int qntyH2O = 1;
int qntyHCl = 1;
int qntyNaOH = 1;

int qntyH3O = 1;
int qntyOH = 10000;

int moleculeQnty;

float totalVolume;

float concentrationH3O;
float concentrationOH;

float pH;
float pOH;

void setup() {
  
  moleculeQnty = qntyH2O + qntyHCl + qntyNaOH + qntyH3O;
  totalVolume = float(moleculeQnty) / 1000;
  
  concentrationH3O = qntyH3O / totalVolume;
  concentrationOH = qntyOH / totalVolume;
  
  if (qntyH3O != qntyOH) {
    pH  = log(concentrationH3O);
    pOH = log(concentrationOH);
  } else {
    pH = 7;
    pOH = 7;
  }

  println("total quantity of molecules: " + moleculeQnty);
  println("total volume: " + totalVolume);
  println("pH: " + pH);
  println("pOH: " + pOH);
}