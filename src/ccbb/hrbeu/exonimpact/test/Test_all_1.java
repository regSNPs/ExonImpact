package ccbb.hrbeu.exonimpact.test;

import java.io.IOException;
import java.sql.SQLException;

import org.apache.commons.configuration2.ex.ConfigurationException;

import ccbb.hrbeu.exonimpact.ExonImpact;

public class Test_all_1 {
	
	public static void test_one() {
		try {
			
			ExonImpact exon_impact = ExonImpact.get_instance("configuration.txt");
			exon_impact.read_from_file("/Users/mengli/Documents/splicingSNP_new/data/build_db/exon_bed.tsv");
			exon_impact.batch_run();
			exon_impact.output_to("/Users/mengli/Documents/splicingSNP_new/data/build_db/test_output_4.csv");
			//exon_impact.build_xml("E:\\limeng\\splicingSNP\\exon_impact_new\\test_1");
			
		} catch (ClassNotFoundException | ConfigurationException | SQLException | IOException  e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	
	public static void testA3SS() {
		try {
			
			ExonImpact exon_impact = ExonImpact.get_instance("configuration.txt");
			//exon_impact.read_from_file("/Users/mengli/Documents/splicingSNP/splicingSNP/exon_impact_new/test_1.txt");
			//exon_impact.run_one("chrY:59336120:59336231:+@chrY:59336348|59336355:59336526:+");
			exon_impact.read_from_file("/Users/mengli/Documents/splicingSNP_new/data/build_db/miso_test/a3ss");
			exon_impact.batch_run();
			exon_impact.output_to("/Users/mengli/Documents/splicingSNP_new/data/build_db/test_output_a3ss_1.csv");
			//exon_impact.build_xml("E:\\limeng\\splicingSNP\\exon_impact_new\\test_1");
			
		} catch (ClassNotFoundException | ConfigurationException | SQLException | IOException  e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	
	public static void testA5SS() {
		try {
			
			ExonImpact exon_impact = ExonImpact.get_instance("configuration.txt");
			//exon_impact.read_from_file("/Users/mengli/Documents/splicingSNP/splicingSNP/exon_impact_new/test_1.txt");
			//exon_impact.run_one("chrY:59336120:59336231:+@chrY:59336348|59336355:59336526:+");
			exon_impact.read_from_file("/Users/mengli/Documents/splicingSNP_new/data/build_db/miso_test/a5ss");
			exon_impact.batch_run();
			exon_impact.output_to("/Users/mengli/Documents/splicingSNP_new/data/build_db/test_output_a5ss_1.csv");
			//exon_impact.build_xml("E:\\limeng\\splicingSNP\\exon_impact_new\\test_1");
			
		} catch (ClassNotFoundException | ConfigurationException | SQLException | IOException  e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	
	public static void testSE() {
		try {
			
			ExonImpact exon_impact = ExonImpact.get_instance("configuration.txt");
			//exon_impact.read_from_file("/Users/mengli/Documents/splicingSNP/splicingSNP/exon_impact_new/test_1.txt");
			//exon_impact.run_one("chrY:59336120:59336231:+@chrY:59336348|59336355:59336526:+");
			exon_impact.read_from_file("/Users/mengli/Documents/splicingSNP_new/data/build_db/miso_test/se");
			exon_impact.batch_run();
			exon_impact.output_to("/Users/mengli/Documents/splicingSNP_new/data/build_db/test_output_se_1.csv");
			//exon_impact.build_xml("E:\\limeng\\splicingSNP\\exon_impact_new\\test_1");
			
		} catch (ClassNotFoundException | ConfigurationException | SQLException | IOException  e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	
	public static void testRI() {
		try {
			
			ExonImpact exon_impact = ExonImpact.get_instance("configuration.txt");
			//exon_impact.read_from_file("/Users/mengli/Documents/splicingSNP/splicingSNP/exon_impact_new/test_1.txt");
			//exon_impact.run_one("chrY:59336120:59336231:+@chrY:59336348|59336355:59336526:+");
			exon_impact.read_from_file("/Users/mengli/Documents/splicingSNP_new/data/build_db/miso_test/ri");
			exon_impact.batch_run();
			exon_impact.output_to("/Users/mengli/Documents/splicingSNP_new/data/build_db/test_output_ri_1.csv");
			//exon_impact.build_xml("E:\\limeng\\splicingSNP\\exon_impact_new\\test_1");
			
		} catch (ClassNotFoundException | ConfigurationException | SQLException | IOException  e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	
	//TODO test A5SS event: chrY:26784814:26784938|26784943:+@chrY:26785033:26785352:+
	public static void main(String[] args) {
		Test_all_1.testA3SS();
		Test_all_1.testA5SS();
		Test_all_1.testSE();
		Test_all_1.testRI();
		//Test_all_1.test_one();
	}

}


