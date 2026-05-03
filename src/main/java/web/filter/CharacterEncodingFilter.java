package web.filter;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

public class CharacterEncodingFilter implements Filter {
    private String encoding = "UTF-8";
    private boolean forceEncoding = true;

    @Override
    public void init(FilterConfig filterConfig) {
        String configuredEncoding = filterConfig.getInitParameter("encoding");
        String configuredForce = filterConfig.getInitParameter("forceEncoding");

        if (configuredEncoding != null && !configuredEncoding.trim().isEmpty()) {
            encoding = configuredEncoding;
        }
        if (configuredForce != null) {
            forceEncoding = Boolean.parseBoolean(configuredForce);
        }
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        if (forceEncoding || request.getCharacterEncoding() == null) {
            request.setCharacterEncoding(encoding);
            response.setCharacterEncoding(encoding);
        }
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Nothing to release.
    }
}
