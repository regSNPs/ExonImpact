package ccbb.hrbeu.exonimpact.test;

import java.io.IOException;
import java.sql.SQLException;

import javax.xml.parsers.ParserConfigurationException;

import org.apache.commons.configuration2.ex.ConfigurationException;
import org.apache.log4j.Logger;

import ccbb.hrbeu.exonimpact.ExonImpact;

public class Test_run_on_2 {
	static Logger log=Logger.getLogger(Test_run_on_2.class);
	
	
	public static void test() {
		try {
			
			ExonImpact exon_impact = ExonImpact.get_instance("configuration.txt");
			exon_impact.run_one("chrY:26952216:26952307:-@chrY:26951604:26951655:-@chrY:26950875:26951104:-");
			
			//exon_impact.output_to("E:\\limeng\\splicingSNP\\exon_impact_new\\test_output_1.csv");
			exon_impact.build_xml("test_1","NM_020420");
			
		} catch (ClassNotFoundException | ConfigurationException | SQLException | IOException | ParserConfigurationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			log.error(e);
			log.error(e.getMessage());
		}
	}
	
	public static void main(String[] args) {
		Test_run_on_2.test();
		
	}
}
