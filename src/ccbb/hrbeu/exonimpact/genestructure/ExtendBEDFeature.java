package ccbb.hrbeu.exonimpact.genestructure;

import org.apache.log4j.Logger;

import htsjdk.tribble.bed.FullBEDFeature;

public class ExtendBEDFeature extends FullBEDFeature {

	Logger log = Logger.getLogger(ExtendBEDFeature.class);

	boolean is_protein_coding = false;

	public ExtendBEDFeature(String chr, int start, int end) {
		super(chr, start, end);
		// TODO Auto-generated constructor stub
	}

	public boolean isIs_protein_coding() {
		return is_protein_coding;
	}

	public void setIs_protein_coding(boolean is_protein_coding) {
		this.is_protein_coding = is_protein_coding;
	}
	
	public Transcript transcript=new Transcript();
	
}
