package ccbb.hrbeu.exonimpact.sequencefeaturewrapper;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;

import org.apache.log4j.Logger;
import org.broad.igv.bbfile.BBFileReader;
import org.broad.igv.bbfile.BigWigIterator;

/**
 * extract phylop_score from bigwig files using IGV bbfile reader
 * 
 * @author Administrator
 *
 */

public class Extractor_phylop implements Extractor {

	private static Logger log = Logger.getLogger(Extractor_phylop.class);

	HashMap<String, BBFileReader> chr_bbfile_map = new HashMap<String, BBFileReader>();

	private static Extractor_phylop instance = null;

	public static Extractor_phylop get_instance() {
		if (instance == null) {
			instance = new Extractor_phylop();
		}

		return instance;
	}

	private Extractor_phylop() {

	}

	public void build_phylop_table(String path) throws IOException {
		File dir = new File(path);
		if (dir.isDirectory() && dir.exists()) {
			log.trace("phylop score file path: " + path);
		} else {
			log.error("phylop files not found" + path);
		}

		String[] file_names = dir.list();
		log.trace("phylop files under the directory is:"+file_names.length);
		for (String ite_file : file_names) {
			String chr = ite_file.split("\\.")[0];

			log.trace("chr: " + chr + " file name: " + path + ite_file);
			chr_bbfile_map.put(chr, new BBFileReader(path + ite_file));

		}

	}

	/**
	 * get average phylop score for a chsomosome location.
	 * 
	 * @param chr
	 * @param start
	 * @param end
	 * @return
	 */

	public ArrayList<Double> extract(String chr, int start, int end) {
		ArrayList<Double> ret = new ArrayList<Double>();

		// TODO I don't know what the fourth parameter mean!
		log.trace("get phylp score from: " + chr + " start: " + start + " end:" + end);

		BigWigIterator iter_bigwig = chr_bbfile_map.get(chr).getBigWigIterator(chr, start, chr, end, true);

		while (iter_bigwig.hasNext()) {
			ret.add((double) iter_bigwig.next().getWigValue());
		}
		// avg_phylop_score= (count==0?count:avg_phylop_score/count );
		//log.debug("don't have phylop score in this region: " + chr + " " + start + " " + end);

		return ret;
	}

	@Override
	public void extract() {
		// TODO Auto-generated method stub

	}

	public static void main(String[] args) {
		try {
			Extractor_phylop.get_instance().build_phylop_table("E:\\limeng\\splicingSNP\\exon_impact_new\\");
			Double score = Extractor_phylop.get_instance().extract("chrY", 1000000, 1060050).get(0);

			System.out.println(score);

		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

}
