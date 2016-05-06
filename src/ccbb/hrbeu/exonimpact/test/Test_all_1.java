package ccbb.hrbeu.exonimpact.test;

import java.io.IOException;
import java.sql.SQLException;

import org.apache.commons.configuration2.ex.ConfigurationException;

import ccbb.hrbeu.exonimpact.ExonImpact;

public class Test_all_1 {
	
	public static void test_one() {
		try {
			
			ExonImpact exon_impact = ExonImpact.get_instance("configuration.txt");
			exon_impact.read_from_file("/Users/mengli/Documents/splicingSNP/exon_impact_new/test_1.txt");
			exon_impact.batch_run();
			exon_impact.output_to("/Users/mengli/Documents/splicingSNP/exon_impact_new/test_output_1.csv");
			//exon_impact.build_xml("E:\\limeng\\splicingSNP\\exon_impact_new\\test_1");
			
		} catch (ClassNotFoundException | ConfigurationException | SQLException | IOException  e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	
	public static void testA3SS() {
		try {
			
			ExonImpact exon_impact = ExonImpact.get_instance("configuration.txt");
			//exon_impact.read_from_file("/Users/mengli/Documents/splicingSNP/splicingSNP/exon_impact_new/test_1.txt");
			//exon_impact.run_one("chrY:59336120:59336231:+@chrY:59336348|59336355:59336526:+");
			exon_impact.read_from_file("/Users/mengli/Documents/splicingSNP/splicingSNP/exon_impact_new/miso_test/a3ss");
			exon_impact.batch_run();
			exon_impact.output_to("/Users/mengli/Documents/splicingSNP/splicingSNP/exon_impact_new/test_output_a3ss_1.csv");
			//exon_impact.build_xml("E:\\limeng\\splicingSNP\\exon_impact_new\\test_1");
			
		} catch (ClassNotFoundException | ConfigurationException | SQLException | IOException  e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	
	public static void testA5SS() {
		try {
			
			ExonImpact exon_impact = ExonImpact.get_instance("configuration.txt");
			//exon_impact.read_from_file("/Users/mengli/Documents/splicingSNP/splicingSNP/exon_impact_new/test_1.txt");
			//exon_impact.run_one("chrY:59336120:59336231:+@chrY:59336348|59336355:59336526:+");
			exon_impact.read_from_file("/Users/mengli/Documents/splicingSNP/splicingSNP/exon_impact_new/miso_test/a5ss");
			exon_impact.batch_run();
			exon_impact.output_to("/Users/mengli/Documents/splicingSNP/splicingSNP/exon_impact_new/test_output_a5ss_1.csv");
			//exon_impact.build_xml("E:\\limeng\\splicingSNP\\exon_impact_new\\test_1");
			
		} catch (ClassNotFoundException | ConfigurationException | SQLException | IOException  e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	
	public static void testSE() {
		try {
			
			ExonImpact exon_impact = ExonImpact.get_instance("configuration.txt");
			//exon_impact.read_from_file("/Users/mengli/Documents/splicingSNP/splicingSNP/exon_impact_new/test_1.txt");
			//exon_impact.run_one("chrY:59336120:59336231:+@chrY:59336348|59336355:59336526:+");
			exon_impact.read_from_file("/Users/mengli/Documents/splicingSNP/splicingSNP/exon_impact_new/miso_test/se");
			exon_impact.batch_run();
			exon_impact.output_to("/Users/mengli/Documents/splicingSNP/splicingSNP/exon_impact_new/test_output_se_1.csv");
			//exon_impact.build_xml("E:\\limeng\\splicingSNP\\exon_impact_new\\test_1");
			
		} catch (ClassNotFoundException | ConfigurationException | SQLException | IOException  e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	public static void testRI() {
		try {
			
			ExonImpact exon_impact = ExonImpact.get_instance("configuration.txt");
			//exon_impact.read_from_file("/Users/mengli/Documents/splicingSNP/splicingSNP/exon_impact_new/test_1.txt");
			//exon_impact.run_one("chrY:59336120:59336231:+@chrY:59336348|59336355:59336526:+");
			exon_impact.read_from_file("/Users/mengli/Documents/splicingSNP/splicingSNP/exon_impact_new/miso_test/ri");
			exon_impact.batch_run();
			exon_impact.output_to("/Users/mengli/Documents/splicingSNP/splicingSNP/exon_impact_new/test_output_ri_1.csv");
			//exon_impact.build_xml("E:\\limeng\\splicingSNP\\exon_impact_new\\test_1");
			
		} catch (ClassNotFoundException | ConfigurationException | SQLException | IOException  e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	
	
	public static void main(String[] args) {
		//Test_all_1.testA3SS();
		//Test_all_1.testA5SS();
		//Test_all_1.testSE();
		//Test_all_1.testRI();
		Test_all_1.test_one();
		
	}

}
