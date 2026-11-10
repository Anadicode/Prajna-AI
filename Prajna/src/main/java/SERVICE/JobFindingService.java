package SERVICE;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;

import org.json.JSONArray;
import org.json.JSONObject;

public class JobFindingService {

    private static final String API_URL =
            "https://openrouter.ai/api/v1/chat/completions";

    private static final String MODEL =
            "nvidia/nemotron-3.5-super-vl:free";

    private final HttpClient client = HttpClient.newBuilder()
            .connectTimeout(Duration.ofSeconds(20))
            .build();

    
    public String findResumeBasedJobs(String resumeText)
            throws IOException, InterruptedException {

        String apiKey = System.getenv("nemotron");

        if (apiKey == null || apiKey.isBlank()) {
            throw new IllegalStateException("API key missing.");
        }

        JSONObject requestBody = new JSONObject()
                .put("model", MODEL)
                .put("messages", new JSONArray()
                        .put(new JSONObject()
                                .put("role", "system")
                                .put("content",
                                        "You are a professional resume reviewer. "
                                        + "Give honest job suggetion for IT roles "))
                        .put(new JSONObject()
                                .put("role", "user")
                                .put("content",
                                        "Analyze this resume for IT roles. "                                     
                                        + "based upon the given skills in the resume, and don't give me any fluffy context " 
                                        + "your main focous should be recomending job roles and explain why these job roles mathches for candidate"	
                                        + resumeText)))
                .put("max_tokens", 3000);

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(API_URL))
                .timeout(Duration.ofSeconds(120))
                .header("Authorization", "Bearer " + apiKey)
                .header("Content-Type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(
                        requestBody.toString()))
                .build();

        HttpResponse<String> response = client.send(
                request,
                HttpResponse.BodyHandlers.ofString());

        if (response.statusCode() != 200) {
            throw new IOException(
                    "API error: " + response.statusCode()
                            + " - " + response.body());
        }

        JSONObject result = new JSONObject(response.body());
        
        //System.out.println(result);

        return result.getJSONArray("choices")
                .getJSONObject(0)
                .getJSONObject("message")
                .getString("content");
    }
}
