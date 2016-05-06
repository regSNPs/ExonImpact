package ccbb.hrbeu.exonimpact.sequencefeaturewrapper;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;

import org.apache.log4j.Logger;

import ccbb.hrbeu.exonimpact.genestructure.ExtendBEDFeature;
import ccbb.hrbeu.exonimpact.genestructure.ExternBEDCodec;
import ccbb.hrbeu.exonimpact.genestructure.Transcript;
import htsjdk.tribble.AbstractFeatureReader;
import htsjdk.tribble.CloseableTribbleIterator;
import htsjdk.tribble.index.Index;
import htsjdk.tribble.index.IndexFactory;
import htsjdk.tribble.readers.LineIterator;

public class Bed_region_extractor implements Extractor {

	Logger log = Logger.getLogger(Bed_region_extractor.class);

	private Index index;

	private AbstractFeatureReader<ExtendBEDFeature, LineIterator> source;

	private static Bed_region_extractor instance = null;

	public static Bed_region_extractor get_instance() {
		if (instance != null)
			return instance;
		else
			instance = new Bed_region_extractor();

		return instance;
	}

	public void build_index(String path_to_bed) {
		index = IndexFactory.createIntervalIndex(new File(path_to_bed), new ExternBEDCodec());

		source = (AbstractFeatureReader<ExtendBEDFeature, LineIterator>) AbstractFeatureReader
				.getFeatureReader(path_to_bed, new ExternBEDCodec(), index);

	}

	@SuppressWarnings("deprecation")
	public ArrayList<Transcript> getTranscripts(String chr, long beg, long end) {
		ArrayList<Transcript> transcripts = new ArrayList<Transcript>();
		try {
			CloseableTribbleIterator<ExtendBEDFeature> iter = source.query(chr, (int) beg, (int) end);
			while (iter.hasNext()) {
				ExtendBEDFeature cur_iter = iter.next();
				
				Transcript t = cur_iter.transcript;
				
				t.setIs_protein_coding(cur_iter.isIs_protein_coding());
				
				t.setTx_start(cur_iter.getStart());
				t.setTx_end(cur_iter.getEnd());
				t.setChr(cur_iter.getChr());
				t.setStrand(cur_iter.getStrand());
				t.setTranscript_id(cur_iter.getName());

				transcripts.add(t);
			}

		} catch (IOException e) {
			System.out.println(e.getMessage());
		}
		return transcripts;
		
	}

	@Override
	public void extract() {
		// TODO Auto-generated method stub

	}

	public static void main(String[] args) {
		Bed_region_extractor.get_instance()
				.build_index("E:\\limeng\\splicingSNP\\miso_events\\refGene_extern_hg19.bed");
		ArrayList<Transcript> trans = Bed_region_extractor.get_instance().getTranscripts("chr1", 910578, 917497);

		for (Transcript iter_trans : trans) {

			System.out.print(iter_trans.getChr() + "\t");
			System.out.print(iter_trans.getTx_start() + "\t");
			System.out.print(iter_trans.getTx_end() + "\t");

			System.out.print(iter_trans.getExons().get(0).getExonBegCoorPos() + "\t");
			System.out.println(iter_trans.getExons().get(0).getExonEndCoorPos());

		}
	}

}
